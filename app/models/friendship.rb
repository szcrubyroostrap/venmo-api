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

  private

  def friendship_with_same_user
    return if user_a != user_b

    errors.add(:base, 'Same user can not be a friend.')
    throw(:abort)
  end

  def friendship_existing_friend
    return if Friendship.where(user_a: user_a, user_b: user_b).empty?

    errors.add(:base, 'Friendship already exists.')
    throw(:abort)
  end
end
