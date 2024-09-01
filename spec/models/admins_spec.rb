# spec/models/admin_spec.rb
require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      admin = Admin.new(name: nil, email: 'test@example.com', password: 'password', password_confirmation: 'password')
      admin.valid?
      expect(admin.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of email' do
      admin = Admin.new(name: 'Admin', email: nil, password: 'password', password_confirmation: 'password')
      admin.valid?
      expect(admin.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email (case insensitive)' do
      existing_admin = FactoryBot.create(:admin, email: 'test@example.com')
      admin = Admin.new(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      admin.valid?
      expect(admin.errors[:email]).to include('has already been taken')
    end

    it 'validates email format' do
      admin_invalid_email = Admin.new(name: 'Admin', email: 'invalid_email', password: 'password', password_confirmation: 'password')
      admin_invalid_email.valid?
      expect(admin_invalid_email.errors[:email]).to include('is invalid')
    end

    it 'validates presence and confirmation of password' do
      admin = Admin.new(name: 'Admin', email: 'test@example.com', password: nil, password_confirmation: 'password')
      admin.valid?
      expect(admin.errors[:password]).to include("can't be blank")

      admin = Admin.new(name: 'Admin', email: 'test@example.com', password: 'password', password_confirmation: 'different_password')
      admin.valid?
      expect(admin.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'validates minimum length of password' do
      admin = Admin.new(name: 'Admin', email: 'test@example.com', password: 'pass', password_confirmation: 'pass')
      admin.valid?
      expect(admin.errors[:password]).to include('is too short (minimum is 8 characters)')
    end
  end
end
