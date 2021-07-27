module Services
  class MustBeFriendsError < StandardError
    def initialize(msg = 'Needs to be friends')
      super(msg)
    end
  end
end
