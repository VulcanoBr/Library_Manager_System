# spec/controllers/subjects_controller_spec.rb

require 'rails_helper'

RSpec.describe SubjectsController, type: :controller do
  let(:admin) { create(:admin) } # Assumindo que você tenha um factory chamado user com trait :admin
  #before(:each) do
  #  Subject.destroy_all
 # end
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
    let(:subject) { create(:subject) } # Supondo que você tenha um factory para a model Subject

    it 'returns a success response' do
      get :show, params: { id: subject.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:subject) } # Supondo que você tenha um factory para a model Subject

    context 'with valid params' do
      it 'creates a new Subject' do
        expect {
          post :create, params: { subject: valid_attributes }
        }.to change(Subject, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Subject' do
        expect {
          post :create, params: { subject: { invalid: 'data' } }
        }.not_to change(Subject, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:subject) { create(:subject) } # Supondo que você tenha um factory para a model Subject
    let(:new_attributes) { { name: 'New Name Subject' } }

    context 'with valid params' do
      it 'updates the requested subject' do
        patch :update, params: { id: subject.id, subject: new_attributes }
        subject.reload
        expect(subject.name).to eq('New Name Subject')
      end
    end

    context 'with invalid params' do
      it 'does not update the subject' do
        patch :update, params: { id: subject.id, subject: { invalid: 'data' } }
        subject.reload
        expect(subject.name).not_to eq('New Name')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subject) { create(:subject) } # Supondo que você tenha um factory para a model Subject

    it 'destroys the requested subject' do
      expect {
        delete :destroy, params: { id: subject.id }
      }.to change(Subject, :count).by(-1)
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
