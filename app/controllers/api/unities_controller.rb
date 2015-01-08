class API::UnitiesController < ApplicationController
  

  # GET /unities
  def index
    @unities = Unity.all
    render json: @unities
  end

end
