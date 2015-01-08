class ApplicationController < ActionController::API
  
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # protect_from_forgery with: :null_session
  before_action :authenticate

  protected

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        @authenticated = User.find_by(token: token)
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="API"'
      render json: 'Bad credentials', status: :unauthorized
    end

  private

    def alias_attributes(params,alias_key)
      p params[alias_key]
      if attributes = params[alias_key]
        params["#{alias_key}_attributes"] = attributes
      end
      params.delete alias_key
      params
    end  
end
