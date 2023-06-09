# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort{|a,b|
       b.favorites.where(created_at: from...to).size <=>
       a.favorites.where(created_at: from...to).size
      }
  end

  def show
    @book = Book.new
    @bookid = Book.find(params[:id])
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: @bookid.user.id, book_id: @bookid.id)
      current_user.view_counts.create(book_id: @bookid.id)
    end
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
    unless @bookid.user.id == current_user.id
      redirect_to :books
    end
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

     def is_matching_login_user
       user = current_user
       unless user.id == current_user.id
         redirect_to user_session_path
       end
     end
end
