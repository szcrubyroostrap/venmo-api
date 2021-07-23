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
describe Payment, type: :model do
  describe 'relationships' do
    it 'belongs to sender' do
      p = Payment.reflect_on_association(:sender)
      expect(p.macro).to eq(:belongs_to)
    end
    it 'belongs to receiver' do
      p = Payment.reflect_on_association(:receiver)
      expect(p.macro).to eq(:belongs_to)
    end
  end
end
