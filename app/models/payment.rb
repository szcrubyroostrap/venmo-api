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
class Payment < ApplicationRecord
  belongs_to :sender, class_name: 'User', inverse_of: :payments
  belongs_to :receiver, class_name: 'User', inverse_of: :incoming_payments
end
