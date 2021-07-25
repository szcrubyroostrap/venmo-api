module Services
  class CreditTransferError < StandardError
    def initialize(msg = 'Error trying to get credit')
      super(msg)
    end
  end
end
