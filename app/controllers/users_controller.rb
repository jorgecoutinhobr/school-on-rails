class UsersController < ApplicationController
  skip_before_action :require_authentication, only: %i[new create]
  before_action :set_user, only: %i[edit update registration]
  before_action :can_edit_user?, only: %i[edit update registration]

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
      flash[:alert] = 'Failed to create user'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User updated successfully'
      redirect_to users_path
    else
      flash[:alert] = 'Failed to update user'
      render :edit, status: :unprocessable_entity
    end
  end

  def registration
    if @user.address.blank?
      @address = @user.build_address
      flash[:notice] = 'Address created successfully' if @address.save
    else
      flash[:alert] = 'Error creating address'
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :cpf,
                                 :birthdate, address_attributes: %i[street city state zip_code country])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def can_edit_user?
    return if current_user.id == @user.id

    redirect_to users_path
    flash[:alert] = 'You are not allowed to edit this user'
  end
end
