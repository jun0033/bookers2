# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @userid = User.find(params[:id])
    @book = Book.new
    @mybooks = @userid.books
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path(@book)
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path
    else
      render :edit
    end
  end

  def index
    @user = current_user
    @book = Book.new
    @users = User.all
  end

     private
       def book_params
         params.require(:book).permit(:title, :body)
       end

       def user_params
         params.require(:user).permit(:name, :introduction, :profile_image)
       end

       def is_matching_login_user
         user = current_user
         unless user.id == current_user.id
           redirect_to user_session_path
         end
       end

       def ensure_guest_user
         @user = User.find(params[:id])
         if @user.name == "guestuser"
           redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
         end
       end
end
