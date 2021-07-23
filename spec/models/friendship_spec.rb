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
end
