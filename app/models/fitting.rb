class Fitting < ActiveRecord::Base
  has_many :products

  def description3=(value)
    v = value.gsub(/<\/t[hd]><t[hd]>/, ';').gsub(/<\/tr>/, "\n").gsub(/<[^>]+>/, '')
    write_attribute(:description3, v)
  end

  def description3
    header, *body = read_attribute(:description3).split("\n")
    header = header.split(";").join('</th><th>')
    body   = body.map do |line|
      line.split(";").join('</td><td>')
    end.join('</td></tr><tr><td>')

    "<table><thead><tr><th>#{header}</th></tr></thead><tr><td>#{body}</td></tr></table>"
  end
end
