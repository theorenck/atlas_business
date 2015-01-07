class API::IndicatorsController < ApplicationController
  
  before_action :set_indicator, only: [:show, :update, :destroy]

  # GET /indicators
  def index
    @indicators = Indicator.all
    render json: @indicators
  end

  # GET /indicators/1
  def show
    render json: @indicator
  end

  # POST /indicators
  def create
    @indicator = Indicator.new(indicator_params)

    if @indicator.save
      render json: @indicator
    else
      render json: @indicator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /indicators/1
  def update
    if @indicator.update(indicator_params)
      render json: @indicator
    else
      render json: @indicator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /indicators/1
  def destroy
    @indicator.destroy
    head :no_content
  end

  private
    def set_indicator
      @indicator = Indicator.find(params[:id])
    end

    def indicator_params
      # params[:indicator][:query_attributes] = params[:indicator][:query] if params[:indicator][:query]
      # params[:indicator][:query_attributes][:parameters_attributes] = params[:indicator][:query_attributes][:parameters] if params[:indicator][:query_attributes][:parameters]
      
      params.require(:indicator).permit(
        :name,
        :description,
        :unity
      )
    end
end