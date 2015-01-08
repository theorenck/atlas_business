class API::SourcesController < ApplicationController
  # GET /sources
  # GET /sources.json
  def index
    if type = params[:type]
      @sources = Source.where(type: type)
    else
      @sources = Source.all
    end

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
      render json: @source, status: :created, location: api_source_url(@source)
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
      
      params_aliases(params)

      params.require(:source).permit(
        :type,
        :code,
        :name,
        :description,
        :statement,
        :limit,
        :offset,
        :result,
        parameters_attributes:[
          :id,
          :type,
          :name,
          :datatype,
          :value,
          :evaluated,
          :_destroy
        ],
        aggregated_sources_attributes: [
          :id,
          :source_id,
          :aggregation_idl,
          :_destroy
        ],
        executions_attributes: [
          :id,
          :order,
          :function_id,
          parameters_attributes:[
            :id,
            :type,
            :name,
            :datatype,
            :value,
            :evaluated,
            :paraterizable_id,
            :_destroy
          ],
        ]
      )
    end

    def params_aliases(params)
      params[:source] = alias_attributes(params[:source],:parameters)
      params[:source] = alias_attributes(params[:source],:aggregated_sources)
      params[:source] = alias_attributes(params[:source],:executions)
      params[:source][:executions_attributes].each do |execution| 
        execution = alias_attributes(execution,:parameters)
      end
    end
end


