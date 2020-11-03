module Api
  require 'nokogiri'
  require 'open-uri'
  class ProductsController < ApplicationController
    respond_to :json
    before_action :set_product, only: [:show, :update]

    def index
      respond_with Product.order('created_at desc')
    end

    def create
      product_url = params[:product][:url]
      product = Product.find_by(url: product_url)
      if product
        if product.created_at::time <= 1.week.ago
          respond_with :api, product, status: :ok
        else
          scrape_data = scrape_url(product_url)
          product = product.update!(scrape_url)
          respond_with :api, product, status: :ok
        end
      else
        scrape_data = scrape_url(product_url)
        product = Product.create!(scrape_data)
        respond_with :api, product, status: :ok
      end
    end

    private

    def scrape_url(url)
      html = open(url)
      doc = Nokogiri::HTML(html)
      title = doc.css('.title font').text
      description = doc.css('td td td td td td td tr:nth-of-type(2) td, table#lblue:nth-of-type(4) tr:nth-of-type(2) td').text
      price = doc.css('font.bigprice, table#lblue:nth-of-type(4) tr:nth-of-type(2) td').text
      mobile_number = doc.css('#white a img, table#lblue:nth-of-type(2) tr:nth-of-type(7) td:nth-of-type(2)').text

      return  product_info = {
        url: url,
        title: title,
        price: price,
        mobile_number: mobile_number,
        description: description
      }
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:url, :title, :description, :price, :mobile_number)
    end
  end
end