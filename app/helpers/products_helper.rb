module ProductsHelper
  def collapse_table(value)
    if value.to_s.include?('<table>')
      value.gsub('</td><td>', ';').gsub('</th><th>', ';').gsub('</tr>', "\n").gsub(/<\/?t[a-z]+>/, '')
    else
      value
    end
  end
end
