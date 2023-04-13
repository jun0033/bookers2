class UserController < ApplicationController
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path
  end
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def is_matching_login_user
    user = current_user
    unless user.id == current_user.id
      redirect_to post_images_path
    end
  end
end
