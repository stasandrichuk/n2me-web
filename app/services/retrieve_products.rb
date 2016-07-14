class RetrieveProducts
  ENDPOINT = 'https://data.product.theplatform.com/product/data/Product/'.freeze

  Result = ImmutableStruct.new(:products_retrieved?, :error_message)

  def initialize(http, retrieve_media)
    self.http = http
    self.retrieve_media = retrieve_media
  end

  def self.build
    new HTTParty, RetrieveMedia.build
  end

  def call
    result = begin
               http.get(ENDPOINT, query: {
                          'token' => ENV['THEPLATFORM_TOKEN'],
                          'schema' => '2.5.0',
                          'form' => 'cjson',
                          'fields' => 'id,title,longDescription,images,scopes,pricingPlan,description'
                        })
             rescue
               nil
             end

    if result && result.parsed_response['entryCount'].to_i > 0
      Product.update_all available: false

      for entry in result.parsed_response['entries']

        product = Product.unscoped.find_or_initialize_by(mpxid: entry['id'])

        product.pricing_plan = entry['pricingPlan']

        product.update_attributes title: entry['title'],
                                  description: entry['longDescription'].empty? ? entry['description'] : entry['longDescription'],
                                  images: entry['images'].values.flatten.map { |i| i['url'] },
                                  available: (product.price > 0)

        product_item_ids = []

        for scope in entry['scopes']
          next if scope['id'].blank?
          product_item = ProductItem.find_or_initialize_by(product_id: product.id,
                                                           mpxid: scope['id'])
          if product_item.media?
            media_result = retrieve_media.call product_item
            product_item.raw = media_result.raw if media_result.media_retrieved?
          end
          begin
            product_item.update_attributes(
              title: scope['title'],
              description: scope['description']
            )
          rescue Exception => e
            puts e.message
          end
          product_item_ids << product_item.id
        end

        product.product_items.where('id NOT IN (?)', product_item_ids).destroy_all
      end
      Result.new(products_retrieved: true)
    else
      Result.new(products_retrieved: false, error_message: 'Failed to retrieve products')
    end
  end

  private

  attr_accessor :http, :retrieve_media
end
