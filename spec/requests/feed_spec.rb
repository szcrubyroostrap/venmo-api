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
    let(:time) { Time.zone.local(2021, 7, 26, 9, 0, 0) }
    before do
      Timecop.freeze(time)
      FundTransferService.new(user_a, user_b, 500.0, 'lorem ipsum').pay
      Timecop.travel(time + 5.seconds)
      FundTransferService.new(user_b, user_c, 300.0, 'foo bar baz').pay
    end

    after { Timecop.return }

    it 'returns http success' do
      subject
      expect(response).to be_successful
    end
    it 'returns order payments resume on feed' do
      subject
      dates = response.parsed_body['feed'].map do |item|
        /^\w+ paid \w+ on (?<date>\d{4}(?:-\d{2}){2} \d{2}(?::\d{2}){2} UTC) - [\w ]+$/ =~ item
        Time.zone.parse(date)
      end
      expect(dates.first > dates.last).to eq(true)
    end
    it 'returns correct payment message feed' do
      subject
      expected_feed = [
        'user_b paid user_c on 2021-07-26 09:00:05 UTC - foo bar baz',
        'user_a paid user_b on 2021-07-26 09:00:00 UTC - lorem ipsum'
      ]
      expect(response.parsed_body['feed']).to eq(expected_feed)
    end
    it 'my feed with frend with friends transactions' do
      Timecop.travel(time + 10.seconds)
      FundTransferService.new(user_b, user_a, 500.0, 'for cats').pay
      Timecop.travel(time + 15.seconds)
      FundTransferService.new(user_c, user_d, 900.0, 'car service').pay
      subject
      expected_feed = [
        'user_b paid user_a on 2021-07-26 09:00:10 UTC - for cats',
        'user_b paid user_c on 2021-07-26 09:00:05 UTC - foo bar baz',
        'user_a paid user_b on 2021-07-26 09:00:00 UTC - lorem ipsum'
      ]
      expect(response.parsed_body['feed']).to eq(expected_feed)
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
