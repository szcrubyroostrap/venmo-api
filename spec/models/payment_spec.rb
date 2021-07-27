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

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).is_less_than(1_000) }
  end

  describe '#transaction_summary' do
    let(:user_a) { create :user, amount: 500.0 }
    let(:user_b) { create :user }
    let(:description) { Faker::Lorem.sentence }

    before do
      user_a.add_friend(user_b)
      FundTransferService.new(user_a, user_b, 500.0, description).pay
    end

    let(:message) do
      "#{user_a.username} paid #{user_b.username} on #{user_a.payments.first.created_at} - "\
        "#{user_a.payments.first.description}"
    end

    it 'user_a shows transaction summary' do
      expect(user_a.payments.first.transaction_summary).to eq(message)
    end
    it 'user_b shows transaction summary' do
      expect(user_b.incoming_payments.first.transaction_summary).to eq(message)
    end
  end
end
