class UsersController < ApplicationController
  include Pagy::Backend
  before_action :set_user

  def payment
    user_b = User.find(payment_params[:friend_id])
    FundTransferService.new(@user, user_b, payment_params[:amount],
                            payment_params[:description]).pay
    head :ok
  end

  def feed
    _pagy, my_feed = pagy_array(@user.my_feed, { page: feed_params[:page] })
    render json: { feed: my_feed }, status: :ok
  end

  def balance
    render json: { balance: @user.amount }, status: :ok
  end

  private

  def payment_params
    params.permit(:friend_id, :amount, :description)
  end

  def feed_params
    params.permit(:page)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
