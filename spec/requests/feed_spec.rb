describe 'GET /user/:id/feed', type: :request do
  let(:user_a)  { create(:user, username: 'user_a', amount: 10) }
  let(:user_b)  { create(:user, username: 'user_b', amount: 7500) }
  let(:user_c)  { create(:user, username: 'user_c', amount: 16_000) }
  let(:user_d)  { create(:user, username: 'user_d', amount: 1700) }

  before do
    user_a.add_friend(user_b)
    user_b.add_friend(user_c)
    user_c.add_friend(user_d)
  end

  subject { get "/user/#{user_a.id}/feed" }

  context 'when there are payments and incoming_payments in feed' do
    before do
      FundTransferService.new(user_a, user_b, 500.0, 'lorem ipsum').pay
      FundTransferService.new(user_b, user_a, 500.0, 'for cats').pay
      FundTransferService.new(user_b, user_c, 300.0, 'lorem ipsum').pay
      FundTransferService.new(user_c, user_d, 900.0, 'car service').pay
    end

    it 'returns http success' do
      subject
      expect(response).to be_successful
    end
  end

  context 'when there are not payments in database' do
    before { subject }

    it 'returns http success' do
      expect(response).to be_successful
    end
    it 'return empty array with any payments transaction summary' do
      expect(response.parsed_body.keys).to include('feed')
      expect(response.parsed_body['feed']).to be_empty
    end
  end
end
