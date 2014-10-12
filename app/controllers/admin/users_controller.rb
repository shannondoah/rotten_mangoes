class Admin::UsersController < ApplicationController

  before_filter :admin_only

  def index
    @users = User.all.page(params[:page]).per(6)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "You have successfully added #{@user.firstname}!"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: "#{@user.full_name} was updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    UserMailer.goodbye_email(@user).deliver
    @user.destroy
    redirect_to admin_users_path, notice: "This user has been deleted."
  end

  # PUT /admin/users/:id/switch

  def switch
    @user = User.where(admin: [false,nil]).find(params[:id])
    session[:admin_id] = current_user.id
    session[:user_id] = @user.id
    redirect_to movies_path, notice: "Now imitating user: #{@user.full_name}"
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

end
