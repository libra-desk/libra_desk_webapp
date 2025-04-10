require 'net/http'

class SessionsController < ApplicationController

  # This shows the views for signing up
  def new_signup; end

  # This sends the actual credentials as a POST req to the auth controller
  def signup
    uri = URI("#{AUTH_MS_ROOT_PATH}/signup")
    response = post_to_auth_ms(signup_params, uri)

    response_body = JSON.parse(response.body)
    if response.code == '201'
      session[:jwt_token] = response_body[:token]
      # redirect_to root_path, notice: "Signed up successfully"
    else
      render :new_signup
    end
  end

  def new_login; end

  def login
    uri = URI("#{AUTH_MS_ROOT_PATH}/login")
    response = post_to_auth_ms(login_params, uri)

    response_body = JSON.parse(response.body)
    if response.code == '200'
      session[:jwt_token] = response_body[:token]
      flash[:notice] = "Signed up"
      # redirect_to root_path, notice: "Signed up successfully"
    else
      render :new_login
    end
  end

  private

  def post_to_auth_ms payload, uri
    Net::HTTP.post(uri, 
                   payload.to_json, 
                   'Content-type' => 'application/json'
                  )
  end

  def signup_params
    params.permit(:email,
                  :password,
                  :password_confirmation
                 )
  end

  def login_params
    params.permit(:email,
                  :password
                 )
  end
end
