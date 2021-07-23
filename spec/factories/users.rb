# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  amount     :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user do
    amount { 0.0 }
  end
end
