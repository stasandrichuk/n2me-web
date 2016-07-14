require 'rails_helper'

RSpec.describe ProductItem, type: :model, broken: true do
  describe '#media?' do
    it 'is true for Media' do
      pi = ProductItem.new mpxid: 'http://data.media2.theplatform.com/media/data/Media/373829661'
      expect(pi).to be_media
    end

    it 'is false for Subscription' do
      pi = ProductItem.new mpxid: 'http://data.product.theplatform.com/product/data/Subscription/20185841'
      expect(pi).not_to be_media
    end
  end

  describe '#thumbnail_url' do
    let(:product_item) { FactoryGirl.build :product_item }

    it 'returns default thumb url from raw' do
      expect(product_item.thumbnail_url).to eq 'http://pmd369599tn.download.theplatform.com.edgesuite.net/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg'
    end
  end
end
