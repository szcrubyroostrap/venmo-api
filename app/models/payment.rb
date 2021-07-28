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

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0, less_than: 1000 }

  scope :desc, -> { order(created_at: :desc) }
  scope :feed_load, ->(ids) { where(id: ids).includes(:sender, :receiver).desc }

  def transaction_summary
    "#{sender.username} paid #{receiver.username} on #{created_at} - #{description}"
  end
end
