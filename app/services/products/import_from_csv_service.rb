require 'csv'

module Products
  class ImportFromCsvService

    attr_reader :csv, :file_name, :parsed_csv

    HEADERS_MAPPING = {
      sku: 'item_numbersku',
      upc: 'upc',
      name: 'item_name',
      description: 'item_description',
      price: 'price',
      model_number: 'stylemodelnumbername',
      primary_category: 'primary_category',
      secondary_category: 'subcategory'
    }.freeze

    def initialize(csv: nil)
      @csv = csv
      @parsed_csv = read_csv
    end

    def run
      unless csv?
        @error = { error: 'Incorrect format' }
        return
      end

      bulk_insert
    end

    def success?
      @error.blank?
    end

    private

    def bulk_insert
      binding.irb
      ActiveRecord::Base.transaction do
        Product.insert_all(
          transform_parsed_csv,
          returning: %w[
            id sku upc name description price
            model_number primary_category secondary_category
          ]
        )
      rescue ActiveRecord::Rollback => e
        @error = { error: e.message }
      end
    end

    def csv?
      csv&.content_type.eql?("text/csv")
    end

    def read_csv
      if csv.is_a?(String)
        parse_csv!(csv: csv)
      elsif File.file?(csv)
        parse_csv!(csv: File.open(csv, encoding: "BOM|UTF-8"))
      end
    end

    def parse_csv!(csv:)
      CSV.parse(
        csv,
        headers: true,
        header_converters: :symbol,
        skip_blanks: true
      ).map(&:to_h)
    end

    def transform_parsed_csv
      parsed_csv.map do |row|
        row = row.with_indifferent_access
        transformed_hash = {}
        HEADERS_MAPPING.each_with_object({}) do |(key, csv_header), transformed_hash|
          transformed_hash[key] = row[csv_header]
        end
      end
    end
  end
end
