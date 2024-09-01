# spec/controllers/libraries_controller_spec.rb
require 'rails_helper'

RSpec.describe LibrariesController, type: :controller do
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
      let(:library) { create(:library) }

      it 'returns a success response' do
        get :show, params: { id: library.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:university) { create(:university) }
      context 'with valid params' do
        it 'creates a new library' do
          expect {
            post :create, params: { library: attributes_for(:library, university_id: university.id) }
          }.to change(Library, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new library' do
          expect {
            post :create, params: { library: { name: nil } }
          }.to_not change(Library, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:library) { create(:library) }

      context 'with valid params' do
        it 'updates the library' do
          patch :update, params: { id: library.id, library: { name: 'Updated Library Name' } }
          library.reload
          expect(library.name).to eq('Updated Library Name')
        end
      end

      context 'with invalid params' do
        it 'does not update the library' do
          patch :update, params: { id: library.id, library: { name: nil } }
          library.reload
          expect(library.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:library) { create(:library) }

      it 'destroys the requested library' do
        expect {
          delete :destroy, params: { id: library.id }
        }.to change(Library, :count).by(-1)
        
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
