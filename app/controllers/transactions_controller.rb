class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_payment!

  def new
    gon.client_token = generate_client_token
  end

  def create
    @result = Braintree::Transaction.sale(
              amount: 10,
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      current_user.purchase_cart_movies!
      redirect_to root_url, notice: "Congraulations! Your transaction has been successfully!"
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      render :new
    end
  end

  private
    def check_payment!
      true # Check if payment details are valid/due
    end

    def generate_client_token
      Braintree::ClientToken.generate
    end
end
