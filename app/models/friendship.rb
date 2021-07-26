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
class Friendship < ApplicationRecord
  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validate :friendship_with_same_user, :friendship_existing_friend

  after_destroy :bi_directional_destroy

  private

  def friendship_with_same_user
    return if user_a != user_b

    errors.add(:base, 'Same user can not be a friend.')
  end

  def friendship_existing_friend
    return if Friendship.where(user_a: user_a, user_b: user_b).empty?

    errors.add(:base, 'Friendship already exists.')
  end

  # Destroy if user is removed
  def bi_directional_destroy
    to_destroy = Friendship.find_by(user_a: user_b, user_b: user_a)
    to_destroy&.destroy!
  end
end
