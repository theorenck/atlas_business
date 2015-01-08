class API::FunctionsController < ApplicationController
  
  # GET /functions/1
  def show
    render json: @function
  end
  # GET /functions
  def index
    @functions = Function.all
    render json: @functions
  end

end
