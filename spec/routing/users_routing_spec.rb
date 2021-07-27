describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #payment' do
      expect(post: '/user/1/payment').to route_to(controller: 'users', action: 'payment', id: '1',
                                                  format: :json)
    end
    it 'routes to #feed' do
      expect(get: '/user/1/feed').to route_to(controller: 'users', action: 'feed', id: '1',
                                              format: :json)
    end
    it 'routes to #balance' do
      expect(get: '/user/1/balance').to route_to(controller: 'users', action: 'balance', id: '1',
                                                 format: :json)
    end
  end
end
