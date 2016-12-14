class String
  def remove_bad_characters
    self.tr('‡', '').tr('“', '"').tr('”', '"').tr('–', '-').tr('’', "'")
  end

  def is_number? string
    true if Float(string) rescue false
  end

  def time_format
    if is_number?(self[0])
      if self.include?("-")
        return self.gsub('a', ' a.m.').gsub('p', ' p.m.')
      elsif self[-1] == "p" || self[-1] == "a"
        t = self
        t[-1] = " #{t[-1]}"
        return t += ".m."
      else
        return self
      end
    end
  end

  def sponsors_format
    a = self.split("/")


  end
end