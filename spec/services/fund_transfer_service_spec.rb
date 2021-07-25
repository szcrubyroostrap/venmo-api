describe FundTransferService, type: :service do
  let(:amount) { Faker::Number.within(range: 500..1000).to_f }
  let(:funds) { Faker::Number.within(range: 100..500).to_f }
  let(:user_a) { create :user, amount: amount }
  let(:user_b) { create :user }
  let(:description) { Faker::Lorem.sentence }

  before do
    user_a.add_friend(user_b)
  end

  context 'when Transfer params are valid' do
    it 'transfer money from user_a to user_b' do
      service = FundTransferService.new(user_a, user_b, funds, description)
      service.pay
      expect(user_a.amount).to eq(amount - funds)
      expect(user_b.amount).to eq(funds)
    end
  end

  context 'when Transfer params are invalid' do
    context 'when receiver is not friend' do
      let(:user_c) { create :user }

      it 'raises Services::MustBeFriendsError due to user_a and user_c are not friends' do
        service = FundTransferService.new(user_a, user_c, funds, description)
        expect { service.pay }.to raise_error(Services::MustBeFriendsError)
      end
    end

    context 'when amout is not positive' do
      let(:funds) { Faker::Number.within(range: -500..0).to_f }

      it 'raises Api::NonePositiveAmountError due to amount is negative' do
        service = FundTransferService.new(user_a, user_b, funds, description)
        expect { service.pay }.to raise_error(Api::NonePositiveAmountError)
      end
    end
  end
end
