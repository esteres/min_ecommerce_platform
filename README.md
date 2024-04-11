# Product Import REST API

This REST API service allows for importing and managing product information using the Ruby on Rails framework. It provides endpoints for importing products from a CSV file and listing all products in the system.

## Product Structure

Each product has the following attributes:

- `id`: The unique ID of the product (integer)
- `name`: The name of the product (String)
- `description`: The description of the product (String)
- `price`: The price of the product (Bigdecimal)
- `primary_category`: The name of the primary category of the product (String)
- `secondary_category`: The name of the secondary category of the product (String)
- `model_number`: The model number (String)
- `upc`: The universal product code (String)
- `sku`: The stock keeping unit (String)

## CSV File Format

The CSV file format for importing products is as follows:


| Item Number/SKU | UPC | Item Name | Item Description | Price | Style/Model/Number/Name | Primary Category | Sub-Category |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4355468680 | 123140 | Frilly Pillow | Synthetic | 19.99 | 15587 | Living Room | Textil |
| 001-74227 | 123143 | Carpet | Plyester | 290.99 | M/590X | Apartment | Textile |


## Endpoints

### POST /products

- Accepts CSV file as an input parameter:

  ```json
  {
    "file": <UploadFile name="products.csv">
  }
  
- Validates that the file is present.
- if the file is not provided, returns status code 422
- Creates a product in the database for every record from the CSV file.
- The response code is 201, and the response body is the list of created products in JSON format, including the uniq ids.

  
### GET /products

Returns a JSON of the collection of all products, ordered by ID in increasing order.


Response:
Code: 200

Filter Params:

- name: Returns all products with the given name.
- primary_category: Returns all products with the given primary category.
- model_number: Returns all products with the given model number.
- upc: Returns all products with the given UPC.
- sku: Returns all products with the given SKU.

  

## Quick testing

```shell
curl -X POST -F "file=@/Users/esteban/Documents/Projects/ecommerce_platform/data/products.csv;filename=products.csv;type=text/csv" http://localhost:3000/products -v

curl http://localhost:3000/products\?upc=123143 -v

