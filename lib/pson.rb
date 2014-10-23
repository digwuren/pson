class Numeric
  #
  # Convert this number into a PostScript numeric literal
  # expression.
  #
  def to_postscript
    return to_s
  end
end

class String
  #
  # Convert this string into a PostScript string literal
  # expression.  The hex literal notation will be used if this
  # would produce a shorter expression.
  #
  # Note that PostScript strings are strictly 8-bit.  Thus, this
  # conversion is done byte to byte, not character to character.
  # If this would be a problem, re-encode the string first using
  # the appropriate 8-bit encoding.
  #
  def to_postscript
    result = "("
    self.each_byte do |b|
      case b
      when 0x28, 0x29, 0x5C then
        result << "\\" << b.chr
      when 0x20 .. 0x7E then
        result << b.chr
      else
        result << ("\\%03o" % b)
      end
    end
    result << ")"
    # Would it be shorter as a hex string literal?
    if result.length > self.bytesize * 2 + 2 then
      return "<" + self.unpack('H*').first + ">"
    else
      return result
    end
  end
end

class Symbol
  #
  # Convert this symbol into a PostScript expression evaluating
  # to a PostScript name object.  If the string does not look
  # like a PostScript name, the resulting expression will use
  # the [[cvn]] operator to convert a PostScript string into a
  # PostScript name.
  #
  def to_postscript
    s = self.to_s
    # Does this symbol parse cleanly if treated as a PostScript name?
    # We're deliberately conservative here.
    if s.unpack('C*').all?{ |cp|
        [
          0x30 .. 0x39, # digits
          0x41 .. 0x5A, # uppercase
          0x61 .. 0x7A, # lowercase
          "-_", # special
        ].any?{ |range|
            range.include? cp}} then
      return '/' + s
    else
      # If not, represent the symbol as a string and convert it to name in
      # PostScript.
      return s.to_postscript + " cvn"
    end
  end
end

class Array
  #
  # Convert this array into a PostScript array expression.
  #
  def to_postscript
    result = "["
    each do |item|
      result << " " << item.to_postscript
    end
    return result + " ]"
  end
end

class Hash
  #
  # Convert this hash into a PostScript dictionary expression.
  #
  def to_postscript
    result = "<<"
    each_pair do |name, value|
      result << " " << name.to_postscript
      result << " " << value.to_postscript
    end
    return result + " >>"
  end
end

class TrueClass
  #
  # Convert this Boolean constant into a PostScript literal
  # expression.
  #
  def to_postscript
    return 'true'
  end
end

class FalseClass
  #
  # Convert this Boolean constant into a PostScript literal
  # expression.
  #
  def to_postscript
    return 'false'
  end
end
