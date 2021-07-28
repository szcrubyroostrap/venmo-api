class FundTransferService
  attr_reader :sender, :receiver, :amount, :description

  def initialize(sender, receiver, amount, description)
    @sender      = sender
    @receiver    = receiver
    @amount      = amount
    @description = description
  end

  def pay
    raise Services::MustBeFriendsError unless sender.my_friend?(receiver)

    raise Services::CreditTransferError unless sender.can_send?(amount) || require_credit

    funds_transaction
  end

  private

  def create_payment
    sender.payments.create!(receiver: receiver, amount: amount, description: description)
  end

  def require_credit
    money_transfer = MoneyTransferService.new(Object.new, sender)
    money_transfer.transfer(sender.funds_required(amount).abs)
  end

  def funds_transaction
    ActiveRecord::Base.transaction do
      substracted_amount = sender.subtract_funds(amount)
      receiver.add_funds(substracted_amount)
      create_payment
    end
  end
end
