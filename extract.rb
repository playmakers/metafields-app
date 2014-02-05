require 'open-uri'
require 'nokogiri'
require 'debugger'

url = "http://www.forelle.com/american-football/gloves/adult/nike-vapor-jet-20/12807"
# url = "http://www.forelle.com/american-football/gloves/adult/nike-super-bad-20/12813"

@data = {}

doc = Nokogiri::HTML(open(url))
sizes = doc.css('#size option').map { |n| n[:value] }

current_size = sizes.shift
@data[current_size] = doc.css('#color option').map { |n| n[:value] }

sizes.each do |current_size|
  doc = Nokogiri::HTML(open(url + "/?x_unit=#{current_size}"))
  # debugger
  @data[current_size] = doc.css('#color option').map { |n| n.content }
end


puts @data.inspect
