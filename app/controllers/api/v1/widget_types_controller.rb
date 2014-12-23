class API::V1::WidgetTypesController < ApplicationController
  

  # GET /widget_types
  def index
    @widget_types = WidgetType.all
    render json: @widget_types
  end

end
