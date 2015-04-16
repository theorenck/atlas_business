class API::DashboardsController < ApplicationController
   
  before_action :set_dashboard, only: [:show, :update, :destroy]

  # GET /dashboards
  def index
    if @authenticated.admin
      @dashboards = Dashboard.all  
      render json: @dashboards
    else
      @dashboards = Dashboard.joins(:permissions).where(:permissions => {:user_id => @authenticated.id})
      render json: @dashboards
    end

  end

  # GET /dashboards/1
  def show
    render json: @dashboard
  end

  # POST /dashboards
  def create
    @dashboard = Dashboard.new(dashboard_params)

    if @dashboard.save
      render json: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dashboards/1
  def update
    if @dashboard.update(dashboard_params)
      render json: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dashboards/1
  def destroy
    @dashboard.destroy
    head :no_content
  end

  private
    def set_dashboard
      @dashboard = Dashboard.includes(widgets:[:widget_type, indicator:[source:[:parameters]]]).find(params[:id])
    end

    def dashboard_params
      params.require(:dashboard).permit(
        :name, 
        :description
      )
    end
end
