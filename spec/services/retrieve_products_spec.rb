require 'rails_helper'

RSpec.describe RetrieveProducts, type: :service, broken: true do
  describe '.build' do
    it 'inits, using HTTParty' do
      expect(RetrieveProducts).to receive(:new)
        .with(HTTParty, RetrieveProducts::RetrieveMedia).and_call_original
      expect(RetrieveProducts.build).to be_a(RetrieveProducts)
    end
  end

  describe '#call' do
    let(:retrieve_media) { double }
    before do
      allow(RetrieveProducts::RetrieveMedia).to receive(:new).and_return(retrieve_media)
    end

    context 'remote', :vcr do
      it 'gets products' do
        allow(retrieve_media).to receive(:call).and_return(double(media_retrieved?: false))

        result = RetrieveProducts.build.call

        expect(result).to be_products_retrieved
      end
    end

    it 'handles exception from HTTParty' do
      http = double
      allow(http).to receive(:get).and_raise('Error')

      result = RetrieveProducts.new(http, retrieve_media).call

      expect(result).not_to be_products_retrieved
      expect(result.error_message).not_to be_nil
    end

    it 'creates product with items' do
      entry = { 'id' => 'http://data.product.theplatform.com/product/data/Product/22230892',
                'title' => 'Theory of Everything',
                'longDescription' => 'In the 1960s, Cambridge University...',
                'images' => { 'uncategorized' => [{ 'mediaFileId' => 'http://data.media2.theplatform.com/media/data/MediaFile/373829667', 'height' => 1200, 'width' => 800, 'url' => 'http://someurl.jpg' }] },
                'pricingPlan' => { 'isTaxIncluded' => false, 'isRecurring' => false, 'pricingTiers' => [{ 'absoluteStart' => 1_455_150_720_000, 'absoluteEnd' => 1_483_160_400_000, 'rightsIds' => ['http://data.entitlement.theplatform.com/eds/data/Rights/62384649'], 'subscriptionUnits' => 'month', 'billingFrequency' => 0, 'minimumSubscriptionPeriod' => 0, 'productTagIds' => [], 'productTags' => [], 'amounts' => { 'USD' => 14.99 }, 'isBlackout' => false, 'isActive' => true }], 'masterAgreementStartDate' => 1_455_080_400_000, 'masterAgreementEndDate' => 1_483_160_400_000, 'masterProductTagIds' => [] },
                'scopes' => [{ 'scopeId' => 'http://data.media2.theplatform.com/media/data/Media/373829666', 'id' => 'http://Media/373829666',
                               'guid' => '0E3E367D-715D-134E-5AC0-4185DBD26398',
                               'title' => 'Theory of Everything',
                               'description' => 'scope desc',
                               'fulfillmentStatus' => 'fulfillable' }] }
      http = double
      result = double
      allow(result).to receive(:parsed_response).and_return('entries' => [entry], 'entryCount' => 1)
      allow(http).to receive(:get).and_return(result)

      product = double(id: 123, price: 4.56)
      unscoped = double
      expect(Product).to receive(:unscoped).and_return(unscoped)
      expect(unscoped).to receive(:find_or_initialize_by).with(mpxid: entry['id']).and_return(product)
      expect(product).to receive(:pricing_plan=).with(entry['pricingPlan'])
      expect(product).to receive(:update_attributes).with(
        title: entry['title'],
        description: entry['longDescription'],
        images: ['http://someurl.jpg'],
        available: true
      )

      product_item = double(id: 234, media?: true)
      expect(ProductItem).to receive(:find_or_initialize_by).with(mpxid: 'http://Media/373829666', product_id: product.id).and_return(product_item)
      expect(product_item).to receive(:update_attributes).with(
        title: 'Theory of Everything', description: 'scope desc'
      )
      allow(product).to receive(:product_items).and_return(ProductItem)

      media_result = double(media_retrieved?: true, raw: 'raw data')
      expect(retrieve_media).to receive(:call).with(product_item).and_return(media_result)
      expect(product_item).to receive(:raw=).with('raw data')

      RetrieveProducts.new(http, retrieve_media).call
    end
  end
end
