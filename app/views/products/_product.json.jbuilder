json.extract! product, :id, :url, :title, :description, :price, :mobile_number, :created_at, :updated_at
json.url product_url(product, format: :json)
