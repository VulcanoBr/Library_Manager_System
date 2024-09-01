# spec/models/library_spec.rb
require 'rails_helper'

RSpec.describe Library, type: :model do
  describe 'validations' do
    let(:university) { FactoryBot.create(:university) } # Certifique-se de ter a fábrica de University definida

    it 'validates presence and uniqueness of name (case insensitive)' do
      existing_library = FactoryBot.create(:library, name: 'Library A', university: university)

      library_same_name = Library.new(name: 'Library A', university: university)
      library_same_name.valid?
      expect(library_same_name.errors[:name]).to include('has already been taken')

      library_same_name_different_case = Library.new(name: 'library a', university: university)
      library_same_name_different_case.valid?
      expect(library_same_name_different_case.errors[:name]).to include('has already been taken')

      library_different_name = Library.new(name: 'Library B', university: university)
      library_different_name.valid?
      expect(library_different_name.errors[:name]).not_to include('has already been taken')
    end

    it 'validates presence, uniqueness, and format of email (case insensitive)' do
      existing_library = FactoryBot.create(:library, email: 'test@example.com', university: university)

      library_same_email = Library.new(email: 'test@example.com', university: university)
      library_same_email.valid?
      expect(library_same_email.errors[:email]).to include('has already been taken')

      library_same_email_different_case = Library.new(email: 'TEST@example.com', university: university)
      library_same_email_different_case.valid?
      expect(library_same_email_different_case.errors[:email]).to include('has already been taken')

      library_invalid_email = Library.new(email: 'invalid_email', university: university)
      library_invalid_email.valid?
      expect(library_invalid_email.errors[:email]).to include('is invalid')
    end

    it 'validates presence of university_id, location, borrow_limit, and overdue_fines' do
      library = Library.new # Criar uma nova biblioteca sem os atributos obrigatórios
      library.valid?
      expect(library.errors[:university_id]).to include("can't be blank")
      expect(library.errors[:location]).to include("can't be blank")
      expect(library.errors[:borrow_limit]).to include("can't be blank")
      expect(library.errors[:overdue_fines]).to include("can't be blank")
    end

    it 'validates numericality of borrow_limit and overdue_fines' do
      library = Library.new(borrow_limit: -1, overdue_fines: 0) # Usar valores inválidos para teste
      library.valid?
      expect(library.errors[:borrow_limit]).to include('deve ser maior que zero')
      expect(library.errors[:overdue_fines]).to include('deve ser maior que zero')
    end
  end

  describe ".overdue_fines" do
    it "returns the first overdue fine" do
      create_list(:library, 2, overdue_fines: 5)  # Cria duas bibliotecas com multas
      create(:library, overdue_fines: 10)       # Cria uma biblioteca com multa diferente

      expect(Library.overdue_fines).to eq(5)   # Espera o primeiro valor (5)
    end
  end

  describe 'order libraries by name' do
    it 'should libraries by name' do
      library1 = FactoryBot.create(:library, name: 'Library 1')
      library2 = FactoryBot.create(:library, name: 'Library 2')
      library3 = FactoryBot.create(:library, name: 'Library 3')

      ordered_libraries = Library.ordered_by_name

      expect(ordered_libraries.first.name).to eq('Library 1')
      expect(ordered_libraries[1].name).to eq('Library 2')
      expect(ordered_libraries.last.name).to eq('Library 3')
    end
  end

end
