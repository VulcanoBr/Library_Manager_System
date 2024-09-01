# spec/models/author_spec.rb
require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      author = Author.new(name: nil)
      author.valid?
      expect(author.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of website' do
      author = Author.new(website: nil)
      author.valid?
      expect(author.errors[:website]).to include("can't be blank")
    end

    it 'validates presence of nationality_id' do
      author = Author.new(nationality_id: nil)
      author.valid?
      expect(author.errors[:nationality_id]).to include("can't be blank")
    end

    it 'validates presence of email' do
      author = Author.new(email: nil)
      author.valid?
      expect(author.errors[:email]).to include("can't be blank")
    end

    # Teste para unicidade do website
    it 'validates uniqueness of website (case insensitive)' do
      nationality = FactoryBot.create(:nationality)
      existing_author = FactoryBot.create(:author, website: 'www.example.com', nationality_id: nationality.id)

      author_same_website = Author.new(website: 'www.example.com', nationality_id: nationality.id)
      author_same_website.valid?
      expect(author_same_website.errors[:website]).to include('has already been taken')

      author_different_website = Author.new(website: 'www.ExAmPlE.com', nationality_id: nationality.id)
      author_different_website.valid?
      expect(author_different_website.errors[:website]).to include('has already been taken')
    end

    # Teste para unicidade do email
    it 'validates uniqueness of email (case insensitive)' do
      nationality = FactoryBot.create(:nationality)
      existing_author = FactoryBot.create(:author, email: 'test@example.com', nationality_id: nationality.id)

      author_same_email = Author.new(email: 'test@example.com', nationality_id: nationality.id)
      author_same_email.valid?
      expect(author_same_email.errors[:email]).to include('has already been taken')

      author_different_email = Author.new(email: 'TEST@example.com', nationality_id: nationality.id)
      author_different_email.valid?
      expect(author_different_email.errors[:email]).to include('has already been taken')
    end

    # Teste para formato do email
    it 'validates email format' do
      author = Author.new(email: 'invalid_email')
      author.valid?
      expect(author.errors[:email]).to include('is invalid')
    end
  end

  # ... outros testes de fábrica
end
