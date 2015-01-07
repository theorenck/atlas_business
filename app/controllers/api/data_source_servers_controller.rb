class API::DataSourceServersController < ApplicationController

  before_action :set_data_source_server, only: [:show, :update, :destroy]

  # GET /data_source_servers
  def index
    if @authenticated.admin
      @data_source_servers = DataSourceServer.all
      render json: @data_source_servers
    else
      @data_source_servers = DataSourceServer.joins(:permissions).where(:permissions => {:user_id => @authenticated.id})
      render json: @data_source_servers
    end
  end

  # GET /data_source_servers/1
  def show
    render json: @data_source_server
  end

  # POST /data_source_servers
  def create
    @data_source_server = DataSourceServer.new(data_source_server_params)

    if @data_source_server.save
      render json: @data_source_server
    else
      render json: @data_source_server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_source_servers/1
  def update
    if @data_source_server.update(data_source_server_params)
      render json: @data_source_server, status: :ok
    else
      render json: @data_source_server.errors, status: :unprocessable_entity
    end
  end

  # DELETE /data_source_servers/1
  def destroy
    @data_source_server.destroy
    head :no_content
  end

  private
    def set_data_source_server
      @data_source_server = DataSourceServer.find(params[:id])
    end

    def data_source_server_params
      params.require(:data_source_server).permit(:name, :description,:url)
    end
end
