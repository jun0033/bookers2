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
    if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book)
    else
    @user = current_user
    @books = Book.all
    render :index
    end
  end

  def edit
    @bookid = Book.find(params[:id])
  end

  def destroy
    @bookid = Book.find(params[:id])
    @bookid.delete
    redirect_to books_path
  end

  def update
    @bookid = Book.find(params[:id])
    if @bookid.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@bookid)
    else
    render :edit
    end
  end

   private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
