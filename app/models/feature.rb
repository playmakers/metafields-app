class Feature < ActiveRecord::Base
  belongs_to :product

  def value
    [self.image, self.title, self.description].join('|')
  end

  def value=(raw)
    self.image, self.title, self.description = raw.split('|')
  end
end
