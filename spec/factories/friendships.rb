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
FactoryBot.define do
  factory :friendship do
    user_a_id
    user_b_id
  end
end
