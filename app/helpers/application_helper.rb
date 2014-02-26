module ApplicationHelper

  def development?
    ENV['RACK_ENV'] != 'development'
  end
end
