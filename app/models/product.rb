class Product < ActiveRecord::Base
  has_many   :variants, :dependent => :destroy
  has_many   :features, :dependent => :destroy
  has_many   :wholesalers
  belongs_to :fitting

  has_and_belongs_to_many :tags

  self.inheritance_column = :_type_disabled

  def option(number)
    read_attribute("option#{number}")
  end

  def options
    3.times.map do |index|
      option(index + 1)
    end.compact
  end
end

