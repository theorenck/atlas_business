class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all

    render json: @sources
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])

    render json: @source
  end

  # POST /sources
  # POST /sources.json
  def create
    @source = Source.new(source_params)

    if @source.save
      render json: @source, status: :created, location: @source
    else
      render json: @source.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sources/1
  # PATCH/PUT /sources/1.json
  def update
    @source = Source.find(params[:id])

    if @source.update(source_params)
      head :no_content
    else
      render json: @source.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    head :no_content
  end

  private
    
    def source_params
      params.require(:source).permit(:code)
    end
end
