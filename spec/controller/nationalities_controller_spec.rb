# spec/controllers/nationalities_controller_spec.rb
require 'rails_helper'

RSpec.describe NationalitiesController, type: :controller do
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
      let(:nationality) { create(:nationality) }

      it 'returns a success response' do
        get :show, params: { id: nationality.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new nationality' do
          expect {
            post :create, params: { nationality: { name: 'New Nationality' } }
          }.to change(Nationality, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new nationality' do
          expect {
            post :create, params: { nationality: { name: nil } }
          }.to_not change(Nationality, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:nationality) { create(:nationality) }

      context 'with valid params' do
        it 'updates the nationality' do
          patch :update, params: { id: nationality.id, nationality: { name: 'Updated Nationality' } }
          nationality.reload
          expect(nationality.name).to eq('Updated Nationality')
        end
      end

      context 'with invalid params' do
        it 'does not update the nationality' do
          patch :update, params: { id: nationality.id, nationality: { name: nil } }
          nationality.reload
          expect(nationality.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:nationality) { create(:nationality) }

      it 'destroys the requested nationality' do
        expect {
          delete :destroy, params: { id: nationality.id }
        }.to change(Nationality, :count).by(-1)
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
