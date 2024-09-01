# spec/controllers/education_levels_controller_spec.rb
require 'rails_helper'

RSpec.describe EducationLevelsController, type: :controller do
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
      let(:education_level) { create(:education_level) }

      it 'returns a success response' do
        get :show, params: { id: education_level.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new education level' do
          expect {
            post :create, params: { education_level: { name: 'New Education Level' } }
          }.to change(EducationLevel, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new education level' do
          expect {
            post :create, params: { education_level: { name: nil } }
          }.to_not change(EducationLevel, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:education_level) { create(:education_level) }

      context 'with valid params' do
        it 'updates the education level' do
          patch :update, params: { id: education_level.id, education_level: { name: 'Updated Education Level' } }
          education_level.reload
          expect(education_level.name).to eq('Updated Education Level')
        end
      end

      context 'with invalid params' do
        it 'does not update the education level' do
          patch :update, params: { id: education_level.id, education_level: { name: nil } }
          education_level.reload
          expect(education_level.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:education_level) { create(:education_level) }

      it 'destroys the requested education level' do
        expect {
          delete :destroy, params: { id: education_level.id }
        }.to change(EducationLevel, :count).by(-1)
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
