class ProductsController < ApplicationController

  before_action :local_login
  around_filter :shopify_session

  def show
    @products = ShopifyAPI::Product.find(:all, :params => {
      :collection_id => 13340861
    })
  end

  def metafields
    id = params[:id]
    @product = ShopifyAPI::Product.find(id, :params => { :fields => [:id, :title, :vendor].join(',') })
    metafields = @product.metafields

    if new_metafields = params[:metafields]
      metafields.each(&:destroy)

      metafields = Array(new_metafields).map do |namespace, metafield|
        metafield.map do |key, value|
          if value = render_value(value)
            @product.add_metafield(ShopifyAPI::Metafield.new({
              # :description => "#{namespace} #{key}",
              :namespace   => namespace,
              :key         => key,
              :value       => value,
              :value_type  => 'string'
            }))
          end
        end
      end.flatten.compact
    end

    @metafields = metafields.inject({}) do |hash, metafield|
      hash[metafield.namespace] ||= []
      hash[metafield.namespace] << metafield
      hash
    end
  end

  private
  def render_value(value)
    if value.is_a?(Array)
      if value[1].present?
        value.join('|')
      end
    elsif value.include?(';')
      header, *body = value.split("\n")
      header = header.split(";").join('</th><th>')
      body   = body.map do |line|
        line.split(";").join('</td><td>')
      end.join('</td></tr><tr><td>')

      "<table><thead><tr><th>#{header}</th></tr></thead><tr><td>#{body}</td></tr></table>"
    elsif value.present?
      value
    end
  end
end
