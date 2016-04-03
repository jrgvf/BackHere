class UsersController < BackHereController
  before_action :find_user, only: :update

  def edit
    @user = current_user
  end

  def update
    if @user.update_with_password(user_params)
      clear_avatar if params[:user][:avatar] == ""
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      flash.keep[:info] = "Perfil atualizado com sucesso."
      redirect_to root_path
    else
      flash.now[:error] = "Não foi possível atualizar o perfil."
      render :edit
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :current_password, :avatar, :position)
    end

    def clear_avatar
      if @user.avatar.present?
        @user.avatar.clear
        @user.save
      end
    end

end
