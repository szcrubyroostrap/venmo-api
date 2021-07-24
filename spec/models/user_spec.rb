# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
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

  describe '#pay_to' do
    let(:user_a) { create :user }
    let(:user_b) { create :user }
    let(:amount) { Faker::Number.within(range: 1..1_000).to_f }

    context 'successful payment' do
      before { user_a.add_friend(user_b) }
      it 'Save record' do
        expect { user_a.pay_to(friend: user_b, amount: amount) }.to change { Payment.count }.by(1)
      end
    end
  end
end
