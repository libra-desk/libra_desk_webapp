require "ostruct"
require "net/http"
require "json"

class StudentsController < ApplicationController
  def index
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students")
    student_ms_response = Net::HTTP.get(uri)

    @students = JSON.parse(student_ms_response, object_class: OpenStruct)
  end

  def show
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
    student_ms_response = Net::HTTP.get(uri)

    @student = OpenStruct.new(JSON.parse(student_ms_response))
  end

  def new
    @student = OpenStruct.new
  end

  def create
    student_data = {
      student: {
        name: params[:name],
        branch: params[:branch],
        email: params[:email],
        year_of_study: params[:year_of_study],
        phone_number: params[:phone_number]
      }
    }

    uri = URI("#{STUDENT_MS_ROOT_PATH}/students")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })

    request.body = student_data.to_json
    response = http.request(request)

    if response.is_a? Net::HTTPSuccess
      redirect_to students_path, notice: "Student registration successful"
    else
      @student = OpenStruct.new(student_data[:student])
      render :new
    end
  end

  def edit
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
    student_ms_response = Net::HTTP.get_response(uri)

    if student_ms_response.is_a? Net::HTTPSuccess
      @student = OpenStruct.new(JSON.parse(student_ms_response.body))
    else
      redirect_to students_path, alert: "Failed to fetch the student from the MS"
    end
  end

  def update
    student_data = {
      student: {
        name: params[:name],
        branch: params[:branch],
        email: params[:email],
        year_of_study: params[:year_of_study],
        phone_number: params[:phone_number]
      }
    }

    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Patch.new(uri.path, { "Content-Type" => "application/json" })
    request.body = student_data.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      redirect_to students_path, notice: "Student updated successfully"
    else
      flash[:alert] = "Failed to update student"
      render :edit
    end
  end

  def destroy
    begin
      RestClient.delete("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
      flash[:notice] = "Student is no longer a member"
    rescue RestClient::ExceptionWithResponse => e
      flash[:alert] = "ERROR: #{e}"
    ensure
      redirect_to students_path
    end
  end
end
