# spec/controllers/languages_controller_spec.rb
require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do
  let(:admin) { create(:admin) }
  #before(:each) do
 #   Language.destroy_all
  #end
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
      let(:language) { create(:language) }

      it 'returns a success response' do
        get :show, params: { id: language.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new language' do
          expect {
            post :create, params: { language: { name: 'Spanish' } }
          }.to change(Language, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new language' do
          expect {
            post :create, params: { language: { name: nil } }
          }.to_not change(Language, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:language) { create(:language) }

      context 'with valid params' do
        it 'updates the language' do
          patch :update, params: { id: language.id, language: { name: 'Updated Language' } }
          language.reload
          expect(language.name).to eq('Updated Language')
        end
      end

      context 'with invalid params' do
        it 'does not update the language' do
          patch :update, params: { id: language.id, language: { name: '' } }
          language.reload
          expect(language.name).to_not eq('')
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:language) { create(:language) }

      it 'destroys the requested language' do
        expect {
          delete :destroy, params: { id: language.id }
        }.to change(Language, :count).by(-1)
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
