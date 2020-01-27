json.extract! customer, :id, :names, :email, :contact, :user_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
