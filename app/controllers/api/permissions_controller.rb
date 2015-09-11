class API::PermissionsController < ApplicationController

  before_action :set_permissions, only: [:show, :update, :destroy]

  # GET /permissions
  def index
    @permissions = Permission.all
    render json: @permissions, authenticated: @authenticated
  end

  # GET /permissions/1
  def show
    render json: @permission, authenticated: @authenticated
  end

  # POST /permissions
  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      render json: @permission
    else
      render json: @permission.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permissions/1
  def update
    if @permission.update(permission_params)
      render json: @permission
    else
      render json: @permission.errors, status: :unprocessable_entity
    end
  end

  # DELETE /permissions/1
  def destroy
    @permission.destroy
    head :no_content
  end

  private
    def set_permissions
      @permission = Permission.find(params[:id])
    end

    def permission_params
      params.require(:permission).permit(:user_id, :dashboard_id, :data_source_server_id)
    end
end
