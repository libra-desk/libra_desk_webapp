class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_jwt_token
  helper_method :current_user # To make it available in the views

  private

  def set_jwt_token
    @jwt_token = session[:jwt_token]
    if @jwt_token
      @current_user = JsonWebToken.decode(@jwt_token)
    end
  end

  def current_user
    OpenStruct.new(user_id: @current_user.dig(:user_id),
                   email: @current_user.dig(:email)
                  ) if @current_user
  end
end
