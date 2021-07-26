# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  username   :string           default(""), not null
#  amount     :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe User, type: :model do
  describe 'relationships' do
    it 'has many friendships' do
      u = User.reflect_on_association(:friendships)
      expect(u.macro).to eq(:has_many)
    end
    it 'has many friends' do
      u = User.reflect_on_association(:friends)
      expect(u.macro).to eq(:has_many)
    end
    it 'has many payments' do
      u = User.reflect_on_association(:payments)
      expect(u.macro).to eq(:has_many)
    end
    it 'has many incoming_payments' do
      u = User.reflect_on_association(:incoming_payments)
      expect(u.macro).to eq(:has_many)
    end
    it 'has many friends_payments' do
      u = User.reflect_on_association(:friends_payments)
      expect(u.macro).to eq(:has_many)
    end
    it 'has many friends_incoming_payments' do
      u = User.reflect_on_association(:friends_incoming_payments)
      expect(u.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    subject(:user) { create :user }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:username) }
  end

  describe 'when validates email' do
    subject(:user) { create :user }
    it 'valid' do
      expect(subject).to be_valid
    end
    it 'invalid' do
      subject.email = 'invalid_email'
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid, /Email is invalid/)
    end
  end

  describe 'loads a feed' do
    let(:user_a) { create :user, amount: 500.0 }
    let(:user_b) { create :user }
    let(:description) { Faker::Lorem.sentence }

    before { user_a.add_friend(user_b) }

    context '#all_my_payments' do
      context 'user_a does not have transactions' do
        it 'payments and incoming_payments' do
          expect(user_a.payments.size).to eq(0)
          expect(user_a.incoming_payments.size).to eq(0)
          expect(user_a.all_my_payments.size).to eq(0)
        end
      end

      context 'user_a has' do
        before { FundTransferService.new(user_a, user_b, 500.0, description).pay }

        it 'one payment to user_b' do
          expect(user_a.all_my_payments.size).to eq(1)
        end
        it 'one incoming_payments from user_b' do
          expect(user_a.all_my_payments.size).to eq(1)
        end
        it 'one payment and one incoming_payments from user_b' do
          FundTransferService.new(user_b, user_a, 500.0, description).pay
          expect(user_a.all_my_payments.size).to eq(2)
        end
      end
    end

    context '#my_feed' do
      let(:user_c) { create :user }
      let(:user_d) { create :user }
      before do
        user_b.add_friend(user_c)
        user_c.add_friend(user_d)
        FundTransferService.new(user_a, user_b, 500.0, description).pay
        FundTransferService.new(user_b, user_a, 100.0, description).pay
        FundTransferService.new(user_b, user_c, 400.0, description).pay
      end
      it 'it return my feed and my friends feed' do
        expect(user_a.my_feed.size).to eq(3)
        expect(user_b.my_feed.size).to eq(3)
        expect(user_c.my_feed.size).to eq(3)
        expect(user_d.my_feed.size).to eq(1)
      end
    end
  end

  describe '#add_friend' do
    subject(:user_a) { create :user }
    subject(:user_b) { create :user }

    it 'creates friendship between two users' do
      user_a.add_friend(user_b)
      expect(user_a.friends.ids).to include(user_b.id)
      expect(user_b.friends.ids).to include(user_a.id)
    end

    it 'raise when creates friendship between the same user' do
      expect { user_a.add_friend(user_a) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#my_friend?' do
    subject(:user_a) { create :user }
    let(:user_b) { create :user }
    let(:user_c) { create :user }
    before { user_a.add_friend(user_b) }

    it 'user_a and user_b are friends' do
      expect(user_a.my_friend?(user_b)).to be(true)
    end
    it 'user_a and user_c are not friends' do
      expect(user_a.my_friend?(user_c)).to be(false)
    end
  end

  describe '#add_funds' do
    subject(:user) { create :user }
    let(:valid_amount) { Faker::Number.within(range: 1..1000).to_f }
    let(:invalid_amount) { Faker::Number.within(range: -10..0).to_f }

    it 'charge funds' do
      expect { user.add_funds(valid_amount) }.to change { user.amount }.by(valid_amount)
    end
    it 'raise error due to negative amount' do
      expect { user.add_funds(invalid_amount) }.to raise_error(Api::NonePositiveAmountError)
    end
    it 'raise error when amount is zero' do
      expect { user.add_funds(0.0) }.to raise_error(Api::NonePositiveAmountError)
    end
  end

  describe '#subtract_funds' do
    subject(:user) { create :user }
    let(:valid_amount) { Faker::Number.within(range: 1..1000).to_f }
    let(:invalid_amount) { Faker::Number.within(range: -10..0).to_f }

    it 'charge funds' do
      expect { user.subtract_funds(valid_amount) }.to change { user.amount }.by(-valid_amount)
    end
    it 'raise error due to negative amount' do
      expect { user.subtract_funds(invalid_amount) }.to raise_error(Api::NonePositiveAmountError)
    end
    it 'raise error when amount is zero' do
      expect { user.subtract_funds(0.0) }.to raise_error(Api::NonePositiveAmountError)
    end
  end

  context 'when user requiers a credit' do
    let(:amount) { Faker::Number.within(range: 500..1000).to_f }
    let(:funds) { Faker::Number.within(range: 1000..1500).to_f }
    subject(:user) { create(:user, amount: amount) }

    describe '#funds_required' do
      it 'returns difference between amount and funds' do
        expect(user.funds_required(funds)).to eq(amount - funds)
      end
    end

    describe '#can_send?' do
      let(:minor_funds) { Faker::Number.within(range: 100..500).to_f }

      it 'can send' do
        expect(user.can_send?(minor_funds)).to be(true)
      end
      it 'can not send' do
        expect(user.can_send?(funds)).to be(false)
      end
    end
  end
end
