# -*- encoding: utf-8 -*-

class ProvincesController < ApplicationController

  def index
    Province.pluck(:name, :province_id)
  end

end