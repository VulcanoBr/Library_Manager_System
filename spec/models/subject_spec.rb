# spec/models/subject_spec.rb
require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'validations' do
    it 'validates presence and uniqueness of name (case insensitive)' do
      existing_subject = FactoryBot.create(:subject, name: 'Mathematics')

      subject_same_name = Subject.new(name: 'Mathematics')
      subject_same_name.valid?
      expect(subject_same_name.errors[:name]).to include('has already been taken')

      subject_same_name_different_case = Subject.new(name: 'mathematics')
      subject_same_name_different_case.valid?
      expect(subject_same_name_different_case.errors[:name]).to include('has already been taken')

      subject_different_name = Subject.new(name: 'Physics')
      subject_different_name.valid?
      expect(subject_different_name.errors[:name]).not_to include('has already been taken')
    end

    it 'validates presence of name' do
      subject = Subject.new(name: nil)
      subject.valid?
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end
end
