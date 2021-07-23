# == Schema Information
#
# Table name: friendships
#
#  id         :bigint           not null, primary key
#  user_a_id  :integer
#  user_b_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe Friendship, type: :model do
  describe 'relationships' do
    it 'belongs to user_a' do
      f = Friendship.reflect_on_association(:user_a)
      expect(f.macro).to eq(:belongs_to)
    end
    it 'belongs to user_b' do
      f = Friendship.reflect_on_association(:user_a)
      expect(f.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    subject(:user_a) { create :user }
    subject(:user_b) { create :user }

    context 'when is trying to add same user as a friend' do
      it 'raises error' do
        expect { user_a.add_friend(user_a) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when is trying to add an existing friend' do
      it 'raises error' do
        user_a.add_friend(user_b)
        expect { user_a.add_friend(user_b) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
