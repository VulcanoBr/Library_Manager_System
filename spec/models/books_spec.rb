# spec/models/author_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do

    let(:library) { FactoryBot.create(:library) }
    let(:nationality) { FactoryBot.create(:nationality) }
    #nationality = Nationality.create!(name: 'Filandes')
    let(:author) { FactoryBot.create(:author) }
    let(:subject) { FactoryBot.create(:subject) }
    let(:language) { FactoryBot.create(:language) }
    let(:publisher) { FactoryBot.create(:publisher) }

    it 'validates presence of ISBN' do
      book = Book.new(isbn: '', title: 'Sample Title', published: 'teste', publication_date: Date.today, 
        edition: '1st', cover: 'teste cover', summary: 'Sample Summary', special_collection: 'YES', count: 1, 
        library_id: library.id, subject_id: subject.id, language_id: language.id, publisher_id: publisher.id, 
        author_id: author.id)
          
      book.valid?
      expect(book.errors[:isbn]).to include("can't be blank")
    end

    

    # Exemplo de teste para o título
    it 'validates presence and minimum length of title' do
      book = Book.new(isbn: '1234567890', title: '', published: 'teste', publication_date: Date.today, 
        edition: '1st', cover: 'teste cover', summary: 'Sample Summary', special_collection: 'YES', count: 1, 
        library_id: library.id, subject_id: subject.id, language_id: language.id, publisher_id: publisher.id, 
        author_id: author.id)
      book.valid?
      expect(book.errors[:title]).to include("can't be blank")

      book_short_title = Book.new(isbn: '1234567890', title: '12', published: 'teste', publication_date: Date.today, 
        edition: '1st', cover: 'teste cover', summary: 'Sample Summary', special_collection: 'YES', count: 1, 
        library_id: library.id, subject_id: subject.id, language_id: language.id, publisher_id: publisher.id, 
        author_id: author.id)
      book_short_title.valid?
      expect(book_short_title.errors[:title]).to include('is too short (minimum is 5 characters)')
    end

    it 'validates presence of author_id' do
      book = Book.new(author_id: '')
      book.valid?
      expect(book.errors[:author_id]).to include("can't be blank")
    end

    it 'validates presence of publisher_id' do
      book = Book.new(publisher_id: '')
      book.valid?
      expect(book.errors[:publisher_id]).to include("can't be blank")
    end

    it 'validates presence of edition' do
      book = Book.new(edition: '')
      book.valid?
      expect(book.errors[:edition]).to include("can't be blank")
    end

    it 'validates presence of language_id' do
      book = Book.new(language_id: '')
      book.valid?
      expect(book.errors[:language_id]).to include("can't be blank")
    end

    it 'validates presence of subject_id' do
      book = Book.new(subject_id: '')
      book.valid?
      expect(book.errors[:subject_id]).to include("can't be blank")
    end

    it 'validates presence of library_id' do
      book = Book.new(library_id: '')
      book.valid?
      expect(book.errors[:library_id]).to include("can't be blank")
    end

    it 'validates presence of publication_date' do
      book = Book.new(publication_date: '')
      book.valid?
      expect(book.errors[:publication_date]).to include("can't be blank")
    end

    it 'validates presence and length of summary' do
      book_short_summary = Book.new(summary: 'Too short')
      book_short_summary.valid?
      expect(book_short_summary.errors[:summary]).to include('is too short (minimum is 50 characters)')

      book_valid_summary = Book.new(summary: 'A summary longer than 50 characters will pass this validation as expected.')
      book_valid_summary.valid?
      expect(book_valid_summary.errors[:summary]).not_to include('is too short (minimum is 50 characters)')
    end

    it 'validates presence of count' do
      book = Book.new(count: '')
      book.valid?
      expect(book.errors[:count]).to include("can't be blank")
    end
  end

  describe '.from_library' do
    let(:library) { create(:library) }
    let(:book_in_library) { create(:book, library: library) }
    let(:book_not_in_library) { create(:book) }

    it 'returns books belonging to the specified library' do
      books = Book.from_library(library.id)
      expect(books).to include(book_in_library)
      expect(books).not_to include(book_not_in_library)
    end
  end
end
