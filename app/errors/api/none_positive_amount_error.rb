module Api
  class NonePositiveAmountError < StandardError
    def initialize(msg = 'funds to add must be positive')
      super(msg)
    end
  end
end
