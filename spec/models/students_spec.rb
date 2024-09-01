# spec/models/student_spec.rb
require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      student = Student.new(name: nil)
      student.valid?
      expect(student.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of email' do
      student = Student.new(email: nil)
      student.valid?
      expect(student.errors[:email]).to include("can't be blank")
    end

    it 'validates presence of phone' do
      student = Student.new(phone: nil)
      student.valid?
      expect(student.errors[:phone]).to include("can't be blank")
    end

    it 'validates presence of education_level_id' do
      student = Student.new(education_level_id: nil)
      student.valid?
      expect(student.errors[:education_level_id]).to include("can't be blank")
    end

    it 'validates presence of university_id' do
      student = Student.new(university_id: nil)
      student.valid?
      expect(student.errors[:university_id]).to include("can't be blank")
    end

    it 'validates presence of max_book_allowed' do
      student = Student.new(max_book_allowed: nil)
      student.valid?
      expect(student.errors[:max_book_allowed]).to include("can't be blank")
    end

    it 'validates max_book_allowed greater than zero' do
      student = Student.new(max_book_allowed: 0)
      student.valid?
      expect(student.errors[:max_book_allowed]).to include('deve ser maior que zero')
    end

    it 'validates presence and uniqueness of email (case insensitive)' do
      existing_student = FactoryBot.create(:student, email: 'test@example.com')

      student_same_email = Student.new(email: 'test@example.com')
      student_same_email.valid?
      expect(student_same_email.errors[:email]).to include('has already been taken')

      student_same_email_different_case = Student.new(email: 'TEST@example.com')
      student_same_email_different_case.valid?
      expect(student_same_email_different_case.errors[:email]).to include('has already been taken')
    end

    it 'validates email format' do
      student_valid_email = Student.new(email: 'valid_email@example.com')
      student_valid_email.valid?
      expect(student_valid_email.errors[:email]).not_to include('is invalid')

      student_invalid_email = Student.new(email: 'invalid_email')
      student_invalid_email.valid?
      expect(student_invalid_email.errors[:email]).to include('is invalid')
    end

    it 'validates presence, confirmation, and minimum length of password' do
      student = Student.new(password: 'pass', password_confirmation: 'pass')
      student.valid?
      expect(student.errors[:password]).to include("is too short (minimum is 8 characters)")

      student.password = 'password123'
      student.password_confirmation = 'password123'
      student.valid?
      expect(student.errors[:password]).not_to include("is too short (minimum is 8 characters)")

      student.password_confirmation = 'different_password'
      student.valid?
      expect(student.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end
