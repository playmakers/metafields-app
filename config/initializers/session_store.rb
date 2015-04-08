# Be sure to restart your server when you modify this file.

PlaymakersApp::Application.config.session_store :cookie_store, key: '_playmakers_app_session'

class Shop
  def self.store(session)
    @@session = session
  end

  def self.retrieve(id)
    if @@session
      ShopifyAPI::Session.new(@session.url, @session.token)
    end
  end
end

ShopifySessionRepository.storage = 'Shop'
