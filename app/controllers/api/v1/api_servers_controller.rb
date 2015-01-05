class API::V1::APIServersController < ApplicationController

  before_action :set_api_server, only: [:show, :update, :destroy]

  # GET /api_servers
  def index
    if @authenticated.admin
      @api_servers = APIServer.all
      render json: @api_servers
    else
      @api_servers = APIServer.joins(:permissions).where(:permissions => {:user_id => @authenticated.id})
      render json: @api_servers
    end
  end

  # GET /api_servers/1
  def show
    render json: @api_server
  end

  # POST /api_servers
  def create
    @api_server = APIServer.new(api_server_params)

    if @api_server.save
      render json: @api_server
    else
      render json: @api_server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api_servers/1
  def update
    if @api_server.update(api_server_params)
      render json: @api_server, status: :ok
    else
      render json: @api_server.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api_servers/1
  def destroy
    @api_server.destroy
    head :no_content
  end

  private
    def set_api_server
      @api_server = APIServer.find(params[:id])
    end

    def api_server_params
      params.require(:api_server).permit(:url, :description, :name)
    end
end
