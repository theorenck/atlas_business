class API::V1::DashboardsController < ApplicationController
   
  before_action :set_dashboard, only: [:show, :update, :destroy]

  # GET /dashboards
  def index
    @dashboards = Dashboard.joins(:permissions)
      .where(:permissions => {:user_id => @authenticated.id})
    render json: @dashboards
  end

  # GET /dashboards/1
  def show
    render json: @dashboard
  end

  # POST /dashboards
  def create
    @dashboard = Dashboard.new(dashboard_params)

    if @dashboard.save
      render :show, status: :created, location: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dashboards/1
  def update
    if @dashboard.update(dashboard_params)
      render :show, status: :ok, location: @dashboard
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
      @dashboard = Dashboard.includes(widgets:[:widget_type, indicator:[query:[:parameters]]]).find(params[:id])
    end

    def dashboard_params
      params.require(:dashboard).permit(:code, :description)
    end
end
