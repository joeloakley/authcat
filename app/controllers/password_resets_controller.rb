class PasswordResetsController < ApplicationController

  def new
  
  end


  def create
    user = User.where(email: params[:email]).first

    if user
      user.deliver_password_reset_instructions
      flash[:notice] = "Instructions to reset your password have been emailed to you"

      redirect_to root_path
    else
      flash.now[:error] = "No user was found with email address #{params[:email]}"
      render :new
    end
  end

 def edit
    load_user_using_perishable_token
    @token = @user.perishable_token
  end



  def update
    load_user_using_perishable_token
    @user.password = params[:password]

    if @user.save
      flash[:success] = "Your password was successfully updated"
      redirect_to @user
    else
      render :edit
    end
  end  

  private

  def load_user_using_perishable_token
    @user = User.where(perishable_token: params[:token]).first
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to root_url
    end
  end


end
