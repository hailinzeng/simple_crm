# -*- encoding: utf-8 -*-

class CitiesController < ApplicationController
  before_filter :find_province, only: [ :index ]
  before_filter :find_city,  only: [ :markets ]

  def index
    cities = @province.city_labels unless @province.nil?
    respond_to do |format|
      format.json { render json: cities }
    end
  end

  def markets
    markets = @city.markets.pluck(:name, :id)
    respond_to do |format|
      format.json { render json: markets }
    end
  end

  private
    def find_city
      @city = City.where(city_id: params[:id]).first
    end

    def find_province
      @province = Province.where(province_id: params[:province_id]).first
    end
end