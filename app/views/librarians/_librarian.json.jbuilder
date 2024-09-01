json.extract! librarian, :id, :name, :email, :password, :library, :approved, :created_at, :updated_at
json.url librarian_url(librarian, format: :json)
