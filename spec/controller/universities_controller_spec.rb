# spec/controllers/universities_controller_spec.rb
require 'rails_helper'

RSpec.describe UniversitiesController, type: :controller do
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
      let(:university) { create(:university) }

      it 'returns a success response' do
        get :show, params: { id: university.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new university' do
          expect {
            post :create, params: { university: attributes_for(:university) }
          }.to change(University, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new university' do
          expect {
            post :create, params: { university: { name: nil } }
          }.to_not change(University, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:university) { create(:university) }

      context 'with valid params' do
        it 'updates the university' do
          patch :update, params: { id: university.id, university: { name: 'Updated Name' } }
          university.reload
          expect(university.name).to eq('Updated Name')
        end
      end

      context 'with invalid params' do
        it 'does not update the university' do
          patch :update, params: { id: university.id, university: { name: nil } }
          university.reload
          expect(university.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:university) { create(:university) }

      it 'destroys the requested university' do
        expect {
          delete :destroy, params: { id: university.id }
        }.to change(University, :count).by(-1)
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
