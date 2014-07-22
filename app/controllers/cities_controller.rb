# -*- encoding: utf-8 -*-

class CitiesController < ApplicationController
  before_filter :find_province

  def index
    cities = @province.cities.pluck(:name, :id) unless @province.nil?
    respond_to do |format|
      format.json { render json: cities }
    end 
  end

  private
    def find_province
      @province = Province.where(id: params[:province_id]).first
    end
end