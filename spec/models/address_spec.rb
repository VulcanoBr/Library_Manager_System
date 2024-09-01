# spec/models/address_spec.rb
require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    let(:university) { FactoryBot.create(:university) }

    it 'validates presence of street' do
      address = Address.new(neighborhood: 'Neighborhood', city: 'City', state: 'State', zipcode: '12345', country: 'Country', university: university)
      address.valid?
      expect(address.errors[:street]).to include("can't be blank")
    end

    it 'validates presence of neighborhood' do
      address = Address.new(street: 'Street', city: 'City', state: 'State', zipcode: '12345', country: 'Country', university: university)
      address.valid?
      expect(address.errors[:neighborhood]).to include("can't be blank")
    end

    it 'validates presence of city' do
      address = Address.new(street: 'Street', neighborhood: 'Neighborhood', state: 'State', zipcode: '12345', country: 'Country', university: university)
      address.valid?
      expect(address.errors[:city]).to include("can't be blank")
    end

    it 'validates presence of state' do
      address = Address.new(street: 'Street', neighborhood: 'Neighborhood', city: 'City', zipcode: '12345', country: 'Country', university: university)
      address.valid?
      expect(address.errors[:state]).to include("can't be blank")
    end

    it 'validates presence of zipcode' do
      address = Address.new(street: 'Street', neighborhood: 'Neighborhood', city: 'City', state: 'State', country: 'Country', university: university)
      address.valid?
      expect(address.errors[:zipcode]).to include("can't be blank")
    end

    it 'validates presence of country' do
      address = Address.new(street: 'Street', neighborhood: 'Neighborhood', city: 'City', state: 'State', zipcode: '12345', university: university)
      address.valid?
      expect(address.errors[:country]).to include("can't be blank")
    end
  end
end
