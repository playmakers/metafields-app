class Fitting < ActiveRecord::Base
  has_many :products

  def description3=(value)
    v = value.gsub(/<\/t[hd]><t[hd]>/, ';').gsub(/<\/tr>/, "\n").gsub(/<[^>]+>/, '')
    write_attribute(:description3, v)
  end
end
