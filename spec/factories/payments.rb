# == Schema Information
#
# Table name: payments
#
#  id          :bigint           not null, primary key
#  amount      :float            default(0.0)
#  description :string           default(""), not null
#  sender_id   :integer
#  receiver_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :payment do
    amount { 0.0 }
    description { 'MyString' }
    sender_id { 1 }
    receiver_id { 1 }
  end
end
