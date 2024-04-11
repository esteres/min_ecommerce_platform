class ProductsController < ApplicationController
  def index
    products = Products::PullService.new(filter_params: filter_params).run
    render json: products, each_serializer: ProductSerializer, status: :ok
  end

  def create
    binding.irb
    if !csv_file_param.key?('file')
      render json: { error: 'Missing file' }, status: :unprocessable_entity
      return
    end

    service = Products::ImportFromCsvService.new(csv: csv_file_param['file'])
    service_data = service.run

    if service.success?
      render json: service_data.to_json, status: :created
    else
      render json: @error.to_json, status: :unprocessable_entity
    end
  end

  def csv_file_param
    params.permit(:file)
  end

  def filter_params
    params.permit(:name, :primary_category, :model_number, :upc, :sku)
  end
end
