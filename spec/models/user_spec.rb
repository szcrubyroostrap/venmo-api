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
end
