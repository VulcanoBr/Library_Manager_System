# spec/controllers/books_controller_spec.rb

require 'rails_helper'
require 'faker'

RSpec.describe BooksController, type: :controller do
  describe "while logged in as an admin" do
    let(:admin) { FactoryBot.create(:admin) } # Supondo que exista uma factory para administradores

    before do
      # Faça login como administrador antes de cada teste
      sign_in admin
    end

    describe "GET #index" do
      let(:book) { FactoryBot.create(:book) }
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      let(:book) { FactoryBot.create(:book) }
    
      it "returns a success response" do
        
        get :show, params: { id: book.id }
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      let(:author) { FactoryBot.create(:author) }
      let(:publisher) { FactoryBot.create(:publisher) }
      let(:language) { FactoryBot.create(:language) }
      let(:subject) { FactoryBot.create(:subject) }
      let(:library) { FactoryBot.create(:library) }
      let(:summary) { Faker::Lorem.paragraphs(number: 4).join(' ') }
      let(:valid_params) { { isbn: '123456789012', title: 'Sample Title Exemple', published: Date.today, publication_date: Date.today, 
            edition: '1st', cover: 'teste cover', summary: summary, special_collection: 'YES', count: 1, 
            library_id: library.id, subject_id: subject.id, language_id: language.id, publisher_id: publisher.id, 
            author_id: author.id } }
      
      context "with valid parameters" do
        it "creates a new book" do

          expect {
            post :create, params: { book: valid_params }
          }.to change(Book, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "does not create a new book" do
          expect {
            post :create, params: { book: { title: '' } }
          }.to_not change(Book, :count)
        end
      end
    end

    describe "  PATCH #update" do
      let(:book) { FactoryBot.create(:book) } # Supondo que exista uma factory para livros

      context "with valid parameters" do

        it "updates the requested book" do
          patch :update, params: { id: book.id, book: { title: 'New_title_book_new_2023' } }
          expect(book.reload.title).to eq('New_title_book_new_2023')
        end
      end

      context "with invalid parameters" do
        let(:book) { FactoryBot.create(:book) }
        it "does not update the requested book" do
          patch :update, params: { id: book.id, book: { title: '' } }
          book.reload
          expect(book.title).not_to eq('')
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:book) { FactoryBot.create(:book) } # Supondo que exista uma factory para livros

      it "destroys the requested book" do
        expect {
          delete :destroy, params: { id: book.id }
        }.to change(Book, :count).by(-1)
      end
    end
  end
end
