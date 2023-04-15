class BooksController < ApplicationController
  #before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def show
    @user = current_user
    @book = Book.new
    @books = Book.all
    @bookid = Book.find(params[:id])
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path(@book)
  end
  
  def edit
    @bookid = Book.find(params[:id])
  end
  
   private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
