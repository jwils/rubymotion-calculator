class MyLabel < UILabel
  PADDING = 3
  def append(string)
    self.text= trimmed_text + string
  end

  def trimmed_text
    text[0..-(PADDING+1)]
  end

  def last_char
    trimmed_text[-1]
  end

  def text=(string)
    super(string + " "*PADDING)
  end

  def last_char=(char)
    text[-(PADDING + 1)] = char
  end

  def empty?
    trimmed_text.length == 0
  end
end