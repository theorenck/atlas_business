class API::V1::IndicatorsController < ApplicationController
  
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
      render :show, status: :created, location: @indicator
    else
      render json: @indicator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /indicators/1
  def update
    if @indicator.update(indicator_params)
      render :show, status: :ok, location: @indicator
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
      params.require(:indicator).permit(
        :name,
        :description,
        :unity,
        :query_id,
        query_attributes:[
          :type,
          :statement,
          parameters_attributes:[
            :name,
            :data_type,
            :default_value
          ]
        ]
      )
    end
end