# spec/models/university_spec.rb
require 'rails_helper'

RSpec.describe University, type: :model do
  describe 'validations' do
    it 'validates presence and uniqueness of name (case insensitive)' do
      existing_university = FactoryBot.create(:university, name: 'Sample University')

      university_same_name = University.new(name: 'Sample University')
      university_same_name.valid?
      expect(university_same_name.errors[:name]).to include('has already been taken')

      university_same_name_different_case = University.new(name: 'sample university')
      university_same_name_different_case.valid?
      expect(university_same_name_different_case.errors[:name]).to include('has already been taken')

      university_different_name = University.new(name: 'Another University')
      university_different_name.valid?
      expect(university_different_name.errors[:name]).not_to include('has already been taken')
    end

    it 'validates presence, uniqueness, and format of homepage' do
      existing_university = FactoryBot.create(:university, homepage: 'www.sample.com')

      university_same_homepage = University.new(homepage: 'www.sample.com')
      university_same_homepage.valid?
      expect(university_same_homepage.errors[:homepage]).to include('has already been taken')

      university_same_homepage_different_case = University.new(homepage: 'WWW.SAMPLE.COM')
      university_same_homepage_different_case.valid?
      expect(university_same_homepage_different_case.errors[:homepage]).to include('has already been taken')

      university_invalid_homepage = University.new(homepage: 'invalidhomepage')
      university_invalid_homepage.valid?
      expect(university_invalid_homepage.errors[:homepage]).to include('deve seguir o padrão www. e .com')
    end

    it 'validates presence, uniqueness, and format of email' do
      existing_university = FactoryBot.create(:university, email: 'test@example.com')

      university_same_email = University.new(email: 'test@example.com')
      university_same_email.valid?
      expect(university_same_email.errors[:email]).to include('has already been taken')

      university_same_email_different_case = University.new(email: 'TEST@example.com')
      university_same_email_different_case.valid?
      expect(university_same_email_different_case.errors[:email]).to include('has already been taken')

      university_invalid_email = University.new(email: 'invalid_email')
      university_invalid_email.valid?
      expect(university_invalid_email.errors[:email]).to include('is invalid')
    end
  end
end
