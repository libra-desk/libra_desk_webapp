require 'net/http'
require 'ostruct'

class BooksController < ApplicationController
  def index
    uri = URI("#{BOOK_MS_ROOT_PATH}/books")
    book_ms_response = Net::HTTP.get(uri)
    # OpenStruct is used inorder to do book.title rather than book['title']
    # It creates an object, but it is expensive in terms of performance
    #
    @books = JSON.parse(book_ms_response, object_class: OpenStruct)
  end

  def show
    uri = URI("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}")
    book_ms_response = Net::HTTP.get(uri)

    @book = OpenStruct.new(JSON.parse(book_ms_response))
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
      book_data[:pdf_file] = File.new(params[:pdf_file].path, 'rb')
    end

    payload_body = { book: book_data }

    begin
      # Here we used RestClient for a cleaner syntax for uploading pdfs
      response = RestClient.post("#{BOOK_MS_ROOT_PATH}/books",
                                 payload_body, 
                                 { accept: :json }
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
    uri = URI("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}")
    book_ms_response = Net::HTTP.get_response(uri)

    if book_ms_response.is_a? Net::HTTPSuccess
      @book = OpenStruct.new(JSON.parse(book_ms_response.body))
    else
      redirect_to books_path, alert: "Failed to fetch the book from the MS"
    end
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
    response = RestClient::Request.execute(
      method: :patch,
      url: "#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}",
      payload: payload.compact, # removes nil values if no file is uploaded
      headers: { accept: :json }
    )

    flash[:notice] = "Book updated successfully"
    redirect_to books_path

  rescue RestClient::ExceptionWithResponse => e
    flash[:alert] = "Failed to edit the book"
    redirect_to edit_book_path(params[:id])
  end

  def destroy
    begin 
      RestClient.delete("#{BOOK_MS_ROOT_PATH}/books/#{params[:id]}")
      flash[:notice] = "Book was removed from the library"
    rescue RestClient::ExceptionWithResponse => e
      flash[:alert] = "ERROR: #{e}"
    ensure
      redirect_to books_path
    end
  end

end
