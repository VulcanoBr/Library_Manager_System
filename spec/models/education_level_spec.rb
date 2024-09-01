
# spec/models/education_level_spec.rb
require 'rails_helper'

RSpec.describe EducationLevel, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      education_level = EducationLevel.new(name: nil)
      education_level.valid?
      expect(education_level.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name (case insensitive)' do
      existing_level = FactoryBot.create(:education_level, name: 'Bachelor')

      level_same_name = EducationLevel.new(name: 'Bachelor')
      level_same_name.valid?
      expect(level_same_name.errors[:name]).to include('has already been taken')

      level_same_name_different_case = EducationLevel.new(name: 'bachelor')
      level_same_name_different_case.valid?
      expect(level_same_name_different_case.errors[:name]).to include('has already been taken')

      level_different_name = EducationLevel.new(name: 'Master')
      level_different_name.valid?
      expect(level_different_name.errors[:name]).not_to include('has already been taken')
    end
  end
end
