# spec/controllers/authors_controller_spec.rb
require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:admin) { create(:admin) }

  describe 'when admin is logged in' do
    before do
      sign_in admin
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:author) { create(:author) }

      it 'returns a success response' do
        get :show, params: { id: author.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:nationality) { create(:nationality) }

      context 'with valid params' do
        it 'creates a new author' do
          expect {
            post :create, params: { author: { name: 'New Author', website: 'www.example.com', email: 'new@example.com', nationality_id: nationality.id } }
          }.to change(Author, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new author' do
          expect {
            post :create, params: { author: { name: '', website: 'www.example.com', email: 'new@example.com', nationality_id: nationality.id } }
          }.to_not change(Author, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:author) { create(:author) }

      context 'with valid params' do
        it 'updates the author' do
          patch :update, params: { id: author.id, author: { name: 'Updated Author' } }
          author.reload
          expect(author.name).to eq('Updated Author')
        end
      end

      context 'with invalid params' do
        it 'does not update the author' do
          patch :update, params: { id: author.id, author: { name: '' } }
          author.reload
          expect(author.name).to_not eq('')
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:author) { create(:author) }

      it 'destroys the requested author' do
        expect {
          delete :destroy, params: { id: author.id }
        }.to change(Author, :count).by(-1)
      end
    end
  end

  describe 'when no admin is NOT logged in' do
    before do
      sign_out :admin
    end
    
    describe 'GET #index' do
      it 'redirects to login page if not logged in' do
        get :index
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
