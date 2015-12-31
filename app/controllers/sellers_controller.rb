class SellersController < ApplicationController
  before_action :find_seller, only: :update

  def edit
    @seller = current_seller
  end

  def update
    if @seller.update_with_password(seller_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @seller, :bypass => true
      flash.keep[:info] = "Perfil atualizado com sucesso."
      redirect_to root_path
    else
      flash.now[:error] = "Não foi possível atualizar o perfil."
      render :edit
    end
  end

  private

    def find_seller
      @seller = Seller.find(params[:id])
    end

    def seller_params
      params.require(:seller).permit(:password, :password_confirmation, :current_password, :avatar, :position)
    end

end
