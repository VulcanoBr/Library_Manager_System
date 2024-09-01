# spec/models/telephones_spec.rb
require 'rails_helper'

RSpec.describe Telephone, type: :model do
  describe 'validations' do
    it 'validates presence of phone' do
      telephone = Telephone.new(phone: nil, contact: 'John Doe', email_contact: 'john@example.com')
      telephone.valid?
      expect(telephone.errors[:phone]).to include("can't be blank")
    end

    it 'validates presence of contact' do
      telephone = Telephone.new(phone: '123456789', contact: nil, email_contact: 'john@example.com')
      telephone.valid?
      expect(telephone.errors[:contact]).to include("can't be blank")
    end

    it 'validates presence of email_contact' do
      telephone = Telephone.new(phone: '123456789', contact: 'John Doe', email_contact: nil)
      telephone.valid?
      expect(telephone.errors[:email_contact]).to include("can't be blank")
    end

    it 'validates uniqueness of email_contact (case insensitive)' do
      existing_telephone = FactoryBot.create(:telephone, email_contact: 'test@example.com')

      new_telephone = Telephone.new(phone: '987654321', contact: 'Jane Smith', email_contact: 'test@example.com')
      new_telephone.valid?
      expect(new_telephone.errors[:email_contact]).to include('has already been taken')
    end

    it 'validates email_contact format' do
      valid_emails = ['valid_email@example.com', 'another_valid_email@example.com']
      invalid_emails = ['invalid_email', 'invalid_email@', 'invalid_email@example']

      valid_emails.each do |email|
        telephone = Telephone.new(phone: '123456789', contact: 'John Doe', email_contact: email)
        telephone.valid?
        expect(telephone.errors[:email_contact]).not_to include('is invalid')
      end

      invalid_emails.each do |email|
        telephone = Telephone.new(phone: '123456789', contact: 'John Doe', email_contact: email)
        telephone.valid?
        expect(telephone.errors[:email_contact]).to include('is invalid')
      end
    end
  end
end
