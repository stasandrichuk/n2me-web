namespace :mpx do
  desc 'Retrieve products from MPX'
  task retrieve_products: :environment do
    result = RetrieveProducts.build.call
    if result.products_retrieved?
      puts 'Products retrieved'
    else
      puts result.error_message
    end
  end
end
