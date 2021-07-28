describe 'POST /user/:id/payment', type: :request do
  let(:user_a)   { create(:user, username: 'user_a', amount: 500.0) }
  let(:user_b)   { create(:user, username: 'user_b', amount: 100.0) }
  let(:amount)   { 100 }

  subject do
    post "/user/#{user_a.id}/payment/",
         params: { friend_id: user_b.id, amount: amount, description: 'this is a test' },
         as: :json
  end

  context 'when user_a and user_b are friends' do
    before { user_a.add_friend(user_b) }

    it 'returns http success' do
      subject
      expect(response).to be_successful
    end
    it 'creates a Payment' do
      expect { subject }.to change(Payment, :count).by(1)
    end
    it 'decrease the amount of the sender' do
      previus_amount = user_a.amount
      subject
      expect(user_a.reload.amount).to eq(previus_amount - amount)
    end
    it 'indecrease the amount of the receiver' do
      previus_amount = user_b.amount
      subject
      expect(user_b.reload.amount).to eq(previus_amount + amount)
    end
    context 'when sender has not money' do
      before { user_a.update!(amount: 0) }

      it 'gets money to send to user_b' do
        previus_user_b_amount = user_b.amount
        subject
        expect(user_b.reload.amount).to eq(previus_user_b_amount + amount)
      end
      it 'user_a sends money but his balance is 0' do
        subject
        expect(user_a.reload.amount).to eq(0)
      end
    end
  end

  context 'when user_a and user_b are not friends' do
    it 'returns bad request error' do
      subject
      expect(response).to have_http_status(:bad_request)
    end
    it 'returns correct json body error key' do
      subject
      expect(response.parsed_body.keys).to include('error')
    end
    it 'does not create a payment' do
      expect { subject }.not_to change(Payment, :count)
    end
  end
end
