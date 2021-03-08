# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:id)
  end

  def upload
    rezult = ProductUpload.upload(params[:file])
    if rezult == 'OK'
      redirect_to action: 'index'
    else
      render plain: rezult
    end
  end
end
