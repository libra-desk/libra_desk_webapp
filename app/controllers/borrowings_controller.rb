require 'ostruct'
require 'json'

class BorrowingsController < ApplicationController
  def index
    uri = URI("#{BORROWING_MS_ROOT_PATH}/borrowings")
    borrowing_ms_response = Net::HTTP.get(uri)
    response = JSON.parse(borrowing_ms_response)
    # @borrowings = JSON.parse(borrowing_ms_response, object_class: OpenStruct)

    @borrowings = response.map do |borrowing|
      student = JSON.parse(get_the_student borrowing['student_id'])
      book = JSON.parse(get_the_book borrowing['book_id'])

      OpenStruct.new(
        student: student,
        book: book,
        returned: borrowing['returned'],
        borrowed_on: borrowing['borrowed_at'],
        returned_on: borrowing['returned_at'],
        due_on: borrowing['due_at']
      )
    end
  end

  def create
    # TODO: Here in student_id, you need to pass the current user logged in 
    borrow_payload = {
      student_id: params[:student_id],
      book_id: params[:book_id]
    }

    uri = URI("#{BORROWING_MS_ROOT_PATH}/borrowings")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })

    request.body = borrow_payload.to_json
    response = http.request(request)

    if response.is_a? Net::HTTPSuccess
      flash[:notice] = "Borrowing successful. Happy Reading!"
    else
      flash[:alert] = "Something happened at the borrowing MS"
    end
    redirect_to books_path
  end

  private

  def get_the_book book_id
    uri = URI("#{BOOK_MS_ROOT_PATH}/books/#{book_id}")
    book_ms_response = Net::HTTP.get(uri)
  end

  def get_the_student student_id
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{student_id}")
    student_ms_response = Net::HTTP.get(uri)
  end
end
