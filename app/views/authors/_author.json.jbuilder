json.extract! author, :id, :name, :website, :email, :nationality_id, :created_at, :updated_at
json.url author_url(author, format: :json)
