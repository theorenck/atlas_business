class API::V1::AuthenticationsController < ApplicationController
  
  before_action :authenticate, except: :create

  # POST /authentications
  def create
    @authentication = Authentication.new(authentication_params)

    if @authentication.save
      render json: @authentication, status: :created
    else
      render json: @authentication.errors, status: :unprocessable_entity
    end
  end

  private
    
    def authentication_params
      params.require(:authentication).permit(:username, :password)
    end
end
