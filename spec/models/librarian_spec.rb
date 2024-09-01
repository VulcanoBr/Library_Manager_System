# spec/models/library_spec.rb
require 'rails_helper'

RSpec.describe Librarian, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      librarian = Librarian.new(name: nil)
      librarian.valid?
      expect(librarian.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of library_id' do
      librarian = Librarian.new(library_id: nil)
      librarian.valid?
      expect(librarian.errors[:library_id]).to include("can't be blank")
    end

    it 'validates presence of phone' do
      librarian = Librarian.new(phone: nil)
      librarian.valid?
      expect(librarian.errors[:phone]).to include("can't be blank")
    end

    it 'validates presence of email' do
      librarian = Librarian.new(email: nil)
      librarian.valid?
      expect(librarian.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email (case insensitive)' do
      existing_librarian = FactoryBot.create(:librarian, email: 'test@example.com')

      librarian_same_email = Librarian.new(email: 'test@example.com')
      librarian_same_email.valid?
      expect(librarian_same_email.errors[:email]).to include('has already been taken')

      librarian_same_email_different_case = Librarian.new(email: 'TEST@example.com')
      librarian_same_email_different_case.valid?
      expect(librarian_same_email_different_case.errors[:email]).to include('has already been taken')
    end

    it 'validates email format' do
      librarian_valid_email = Librarian.new(email: 'valid_email@example.com')
      librarian_valid_email.valid?
      expect(librarian_valid_email.errors[:email]).not_to include('is invalid')

      librarian_invalid_email = Librarian.new(email: 'invalid_email')
      librarian_invalid_email.valid?
      expect(librarian_invalid_email.errors[:email]).to include('is invalid')
    end

    it 'validates presence and confirmation of password' do
      librarian = Librarian.new(password: 'password', password_confirmation: 'password')
      librarian.valid?
      expect(librarian.errors[:password_confirmation]).not_to include("can't be blank")
      expect(librarian.errors[:password]).not_to include("can't be blank")

      librarian.password_confirmation = 'different_password'
      librarian.valid?
      expect(librarian.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'validates length of password' do
      librarian_short_password = Librarian.new(password: 'short', password_confirmation: 'short')
      librarian_short_password.valid?
      expect(librarian_short_password.errors[:password]).to include('is too short (minimum is 8 characters)')

      librarian_valid_password = Librarian.new(password: 'password1', password_confirmation: 'password1')
      librarian_valid_password.valid?
      expect(librarian_valid_password.errors[:password]).not_to include('is too short (minimum is 8 characters)')
    end
  end
end

