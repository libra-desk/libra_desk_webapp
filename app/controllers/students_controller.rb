require "ostruct"
require "net/http"
require "json"

class StudentsController < ApplicationController
  def index
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students")
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get(uri.path, auth_headers)
    end
    @students = JSON.parse(response.body, object_class: OpenStruct)
  end

  def show
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get(uri.path, auth_headers)
    end
    @student = OpenStruct.new(JSON.parse(response.body))
  end

  def edit
    uri = URI("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}")
    student_ms_response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get(uri.path, auth_headers)
    end

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
    request = Net::HTTP::Patch.new(uri.path, auth_headers)
    request.body = student_data.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      redirect_to students_path, notice: "Student updated successfully"
    else
      flash.now[:alert] = "Failed to update student"
      render :edit
    end
  end

  def destroy
    begin
      RestClient.delete("#{STUDENT_MS_ROOT_PATH}/students/#{params[:id]}", auth_headers)
      flash[:notice] = "Student is no longer a member"
    rescue RestClient::ExceptionWithResponse => e
      flash[:alert] = "ERROR: #{e}"
    ensure
      redirect_to students_path
    end
  end

  private

  def auth_headers
    {
      Authorization: @jwt_token,
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end
end
