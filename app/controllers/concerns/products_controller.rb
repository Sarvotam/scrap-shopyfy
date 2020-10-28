module Api
  require 'nokogiri'
  require 'open-uri'

  class ProductsController < ApplicationController
    respond_to :json
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
     respond_with Product.order("#{sort_by} #{order}")
    end

    def show
    end
    def new
      @product = Product.new
    end
    def edit
    end

    def create
      # @product = Product.new(product_params)
      product_url = params[:product][:url]
      product = Product.find_by(url: product_url)

      if product
        if product.created_at::time <= 3.seconds.ago
          respond_with :api, product, status: :ok
          redirect_to product, notice: 'Product was already scraped.' 

        end
      else 
        scrape_data = scrape_url(product_url)
        product = Product.create!(scrape_data)
        render json: { errors: event.errors.full_messages }, status: :succesfully_scraped
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

      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:url, :title, :description, :price, :mobile_number)
      end

      def sort_by
        %w(url
           title
           description
           price
           mobile_number).include?(params[:sort_by]) ? params[:sort_by] : 'name'
      end
  
      def order
        %w(asc desc).include?(params[:order]) ? params[:order] : 'asc'
      end
  end
end