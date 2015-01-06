class TypedParametersController < ApplicationController
  # GET /typed_parameters
  # GET /typed_parameters.json
  def index
    @typed_parameters = TypedParameter.all

    render json: @typed_parameters
  end

  # GET /typed_parameters/1
  # GET /typed_parameters/1.json
  def show
    @typed_parameter = TypedParameter.find(params[:id])

    render json: @typed_parameter
  end

  # POST /typed_parameters
  # POST /typed_parameters.json
  def create
    @typed_parameter = TypedParameter.new(typed_parameter_params)

    if @typed_parameter.save
      render json: @typed_parameter, status: :created, location: @typed_parameter
    else
      render json: @typed_parameter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /typed_parameters/1
  # PATCH/PUT /typed_parameters/1.json
  def update
    @typed_parameter = TypedParameter.find(params[:id])

    if @typed_parameter.update(typed_parameter_params)
      head :no_content
    else
      render json: @typed_parameter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /typed_parameters/1
  # DELETE /typed_parameters/1.json
  def destroy
    @typed_parameter = TypedParameter.find(params[:id])
    @typed_parameter.destroy

    head :no_content
  end

  private
    
    def typed_parameter_params
      params.require(:typed_parameter).permit(:datatype, :evaluated)
    end
end
