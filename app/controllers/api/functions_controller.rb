class API::FunctionsController < ApplicationController
  

  # GET /functions
  def index
    @functions = Function.all
    render json: @functions
  end

end
