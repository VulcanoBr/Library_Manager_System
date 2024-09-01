
# spec/models/language_spec.rb
require 'rails_helper'

RSpec.describe Language, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      language = Language.new(name: nil)
      language.valid?
      expect(language.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name (case insensitive)' do
      existing_language = FactoryBot.create(:language, name: 'English')

      language_same_name = Language.new(name: 'English')
      language_same_name.valid?
      expect(language_same_name.errors[:name]).to include('has already been taken')

      language_same_name_different_case = Language.new(name: 'english')
      language_same_name_different_case.valid?
      expect(language_same_name_different_case.errors[:name]).to include('has already been taken')

      language_different_name = Language.new(name: 'Spanish')
      language_different_name.valid?
      expect(language_different_name.errors[:name]).not_to include('has already been taken')
    end
  end
end

