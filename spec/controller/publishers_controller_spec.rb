# spec/controllers/publishers_controller_spec.rb
require 'rails_helper'

RSpec.describe PublishersController, type: :controller do
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
      let(:publisher) { create(:publisher) }

      it 'returns a success response' do
        get :show, params: { id: publisher.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new publisher' do
          expect {
            post :create, params: { publisher: { name: 'New Publisher', website: 'www.example.com', email: 'info@email.com' } }
          }.to change(Publisher, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new publisher' do
          expect {
            post :create, params: { publisher: { name: nil, website: 'www.exemple.com', email: 'info@email.com' } }
          }.to_not change(Publisher, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:publisher) { create(:publisher) }

      context 'with valid params' do
        it 'updates the publisher' do
          patch :update, params: { id: publisher.id, publisher: { name: 'Updated Publisher' } }
          publisher.reload
          expect(publisher.name).to eq('Updated Publisher')
        end
      end

      context 'with invalid params' do
        it 'does not update the publisher' do
          patch :update, params: { id: publisher.id, publisher: { name: nil } }
          publisher.reload
          expect(publisher.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:publisher) { create(:publisher) }

      it 'destroys the requested publisher' do
        expect {
          delete :destroy, params: { id: publisher.id }
        }.to change(Publisher, :count).by(-1)
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
  
    describe 'GET #show' do
        let(:publisher) { create(:publisher) }

        it 'returns a success response' do
          get :show, params: { id: publisher.id }
          expect(response).to redirect_to(new_admin_session_path)
        end
    end

    describe 'DELETE #destroy' do
      let!(:publisher) { create(:publisher) }

      it 'destroys the requested publisher' do

        get :destroy, params: { id: publisher.id }
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
