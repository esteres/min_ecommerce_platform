module Products
  class PullService
    attr_reader :filter_params

    def initialize(filter_params:)
      @filter_params = filter_params
    end

    def run
      products = Product
      if !filter_params.empty?
        filter_params.each do |key, value|
          products = products.where("#{key} = ?", value)
        end
      end

      products.all
    end
  end
end
