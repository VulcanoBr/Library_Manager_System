# spec/controllers/telephones_controller_spec.rb
require 'rails_helper'

RSpec.describe TelephonesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:university) { create(:university) }

  describe 'when admin is logged in' do
    before do
      sign_in admin
    end

    describe 'GET #show' do
      let(:telephone) { create(:telephone, university: university) }

      it 'returns a success response' do
        get :show, params: { id: telephone.id, university_id: university.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'when no admin is NOT logged in' do
    before do
      sign_out :admin
    end
    
    describe 'DELETE #destroy' do
      let(:telephone) { create(:telephone, university: university) }
      it 'redirects to login page if not logged in' do
        delete :destroy, params: { id: telephone.id, university_id: university.id }
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
