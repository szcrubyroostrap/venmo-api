# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  amount     :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :friendships, foreign_key: :user_a_id, inverse_of: :user_a, dependent: :destroy
  has_many :friends, through: :friendships, class_name: 'User', source: :user_b
  has_many :payments, inverse_of: :sender, dependent: :nullify
  has_many :incoming_payments, class_name: 'Payment', inverse_of: :receiver, dependent: :nullify

  def add_friend(user)
    friendships.create!(user_b: user)
    user.friendships.create!(user_b: self)
  end
end
