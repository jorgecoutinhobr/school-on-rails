class UsersController < ApplicationController
  skip_before_action :require_authentication, only: %i[new create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)

    if user.save
      session[:user_id] = user.id
      flash[:notice] = 'User created successfully'
      redirect_to users_path
    else
      flash[:alert] = 'User not created'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
