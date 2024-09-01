# spec/models/nationality_spec.rb
require 'rails_helper'

RSpec.describe Nationality, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      nationality = Nationality.new(name: nil)
      nationality.valid?
      expect(nationality.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name (case insensitive)' do
      existing_nationality = FactoryBot.create(:nationality, name: 'Brazilian')

      nationality_same_name = Nationality.new(name: 'Brazilian')
      nationality_same_name.valid?
      expect(nationality_same_name.errors[:name]).to include('has already been taken')

      nationality_same_name_different_case = Nationality.new(name: 'brazilian')
      nationality_same_name_different_case.valid?
      expect(nationality_same_name_different_case.errors[:name]).to include('has already been taken')

      nationality_different_name = Nationality.new(name: 'American')
      nationality_different_name.valid?
      expect(nationality_different_name.errors[:name]).not_to include('has already been taken')
    end
  end
end
