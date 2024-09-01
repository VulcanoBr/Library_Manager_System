
# spec/models/publisherr_spec.rb
require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    it 'validates presence and uniqueness of name (case insensitive)' do
      existing_publisher = FactoryBot.create(:publisher, name: 'ABC Publishing')

      publisher_same_name = Publisher.new(name: 'ABC Publishing')
      publisher_same_name.valid?
      expect(publisher_same_name.errors[:name]).to include('has already been taken')

      publisher_same_name_different_case = Publisher.new(name: 'abc publishing')
      publisher_same_name_different_case.valid?
      expect(publisher_same_name_different_case.errors[:name]).to include('has already been taken')

      publisher_different_name = Publisher.new(name: 'XYZ Publishing')
      publisher_different_name.valid?
      expect(publisher_different_name.errors[:name]).not_to include('has already been taken')
    end

    it 'validates presence and uniqueness of website (case insensitive) and format' do
      existing_publisher = FactoryBot.create(:publisher, website: 'www.example.com')

      publisher_same_website = Publisher.new(website: 'www.example.com')
      publisher_same_website.valid?
      expect(publisher_same_website.errors[:website]).to include('has already been taken')

      publisher_same_website_different_case = Publisher.new(website: 'WWW.example.com')
      publisher_same_website_different_case.valid?
      expect(publisher_same_website_different_case.errors[:website]).to include('has already been taken')

      publisher_different_website = Publisher.new(website: 'www.newwebsite.com')
      publisher_different_website.valid?
      expect(publisher_different_website.errors[:website]).not_to include('has already been taken')

      publisher_invalid_website_format = Publisher.new(website: 'example.com')
      publisher_invalid_website_format.valid?
      expect(publisher_invalid_website_format.errors[:website]).to include('deve seguir o padrão www. e .com')
    end

    it 'validates presence and uniqueness of email and format' do
      existing_publisher = FactoryBot.create(:publisher, email: 'test@example.com')

      publisher_same_email = Publisher.new(email: 'test@example.com')
      publisher_same_email.valid?
      expect(publisher_same_email.errors[:email]).to include('has already been taken')

      publisher_same_email_different_case = Publisher.new(email: 'TEST@example.com')
      publisher_same_email_different_case.valid?
      expect(publisher_same_email_different_case.errors[:email]).to include('has already been taken')

      publisher_different_email = Publisher.new(email: 'new@example.com')
      publisher_different_email.valid?
      expect(publisher_different_email.errors[:email]).not_to include('has already been taken')

      publisher_invalid_email_format = Publisher.new(email: 'invalidemail.com')
      publisher_invalid_email_format.valid?
      expect(publisher_invalid_email_format.errors[:email]).to include('is invalid')
    end
  end
end
