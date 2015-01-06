class API::V1::DatasourceServersController < ApplicationController

  before_action :set_datasource_server, only: [:show, :update, :destroy]

  # GET /datasource_servers
  def index
    if @authenticated.admin
      @datasource_servers = DatasourceServer.all
      render json: @datasource_servers
    else
      @datasource_servers = DatasourceServer.joins(:permissions).where(:permissions => {:user_id => @authenticated.id})
      render json: @datasource_servers
    end
  end

  # GET /datasource_servers/1
  def show
    render json: @datasource_server
  end

  # POST /datasource_servers
  def create
    @datasource_server = DatasourceServer.new(datasource_server_params)

    if @datasource_server.save
      render json: @datasource_server
    else
      render json: @datasource_server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /datasource_servers/1
  def update
    if @datasource_server.update(datasource_server_params)
      render json: @datasource_server, status: :ok
    else
      render json: @datasource_server.errors, status: :unprocessable_entity
    end
  end

  # DELETE /datasource_servers/1
  def destroy
    @datasource_server.destroy
    head :no_content
  end

  private
    def set_datasource_server
      @datasource_server = DatasourceServer.find(params[:id])
    end

    def datasource_server_params
      params.require(:datasource_server).permit(:url, :description, :name)
    end
end
