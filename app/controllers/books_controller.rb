class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @new_book = Book.new
    @books = Book.all
    @user = current_user
  end

  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def create
    @user = current_user
    @books = Book.all
    @new_book = Book.new(book_params)
    @new_book.user_id = current_user.id
    if @new_book.save
      redirect_to book_path(@new_book.id), notice:'You have created book successfully.'
    else
      render :index
    end
  end

  def edit
    @new_book = Book.new
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to new_user_session_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice:'You have updated book successfully.'
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def ensure_correct_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body, :user)
  end

end
