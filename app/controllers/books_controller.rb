require "net/http"
require "ostruct"

class BooksController < ApplicationController
  def index
      book_ms_response = RestClient.get("#{BOOK_MS_ROOT_PATH}/books",
                                        auth_headers
                                       )
      @books = JSON.parse(book_ms_response, object_class: OpenStruct)
  end

  def show
    response = RestClient.get("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}", auth_headers)
    @book = OpenStruct.new(JSON.parse(response.body))
  end

  def new
    @book = OpenStruct.new
  end

  def create
    book_data = {
      title: params[:title],
      description: params[:description],
      pages: params[:pages],
      isbn: params[:isbn]
    }

    if params[:pdf_file].present?
      book_data[:pdf_file] = File.new(params[:pdf_file].path, "rb")
    end

    payload_body = { book: book_data }

    begin
      response = RestClient.post(
        "#{BOOK_MS_ROOT_PATH}/books",
        payload_body,
        auth_headers
      )

      if response.code == 200 || response.code == 201
        redirect_to books_path, notice: "Book added successfully"
      else
        flash[:alert] = "Book has not been added. There seems to be an error"
        render :new
      end
    rescue RestClient::ExceptionWithResponse => e
      flash[:alert] = "ERROR: #{e}"
      render :new
    end
  end

  def edit
    response = RestClient.get("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}", auth_headers)
    @book = OpenStruct.new(JSON.parse(response.body))
  rescue RestClient::ExceptionWithResponse
    redirect_to books_path, alert: "Failed to fetch the book from the MS" 
  end

  def update
    payload = {
      book: {
        title: params[:title],
        description: params[:description],
        pages: params[:pages],
        isbn: params[:isbn],
        pdf_file: params[:pdf_file]
      }
    }

    RestClient::Request.execute(
      method: :patch,
      url: "#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}",
      payload: payload.compact,
      headers: auth_headers
    )

    flash[:notice] = "Book updated successfully"
    redirect_to books_path
  rescue RestClient::ExceptionWithResponse
    flash[:alert] = "Failed to edit the book"
    redirect_to edit_book_path(params[:id])
  end

  def destroy
    RestClient.delete("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}", auth_headers)
    flash[:notice] = "Book was removed from the library"
  rescue RestClient::ExceptionWithResponse => e
    flash[:alert] = "ERROR: #{e}"
  ensure
    redirect_to books_path
  end

  private

  def auth_headers
    {
      Authorization: @jwt_token,
      accept: :json
    }
  end
end
