describe 'GET /user/:id/balance', type: :request do
  context 'successful' do
    let(:user) { create(:user) }
    subject { get "/user/#{user.id}/balance" }
    before  { subject }

    it 'returns http success' do
      expect(response).to be_successful
    end
    it 'return correct json body key' do
      expect(response.parsed_body.keys).to include('balance')
    end
  end
  context 'error' do
    let(:invalid_user_id) { 10 }
    before { get "/user/#{invalid_user_id}/balance" }

    it 'returns not_found' do
      expect(response).to have_http_status(:not_found)
    end
    it 'returns correct json body error key' do
      expect(response.parsed_body.keys).to include('error')
    end
  end
end
