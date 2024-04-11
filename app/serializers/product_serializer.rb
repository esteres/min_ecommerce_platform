class ProductSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :sku, :price,
      :primary_category, :model_number, :secondary_category, :upc
end
