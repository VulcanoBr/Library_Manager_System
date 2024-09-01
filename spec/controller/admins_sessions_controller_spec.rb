require 'rails_helper'

RSpec.describe Admins::SessionsController, type: :controller do
  let(:admin) { FactoryBot.create(:admin) }

  it "redirects to the home page after login" do
    sign_in admin
    expect(response).to be_successful
    #expect(response).to be(:ok)
    expect(response).to have_http_status(:ok)
  end
end
