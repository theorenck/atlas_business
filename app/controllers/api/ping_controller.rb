class API::PingController < ApplicationController
  
  before_action :authenticate, except: :index

  # GET /ping
  def index
    render json: {alive: true}, status: :ok
  end
end