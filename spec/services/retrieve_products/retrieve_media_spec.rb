require 'rails_helper'

RSpec.describe RetrieveProducts::RetrieveMedia, type: :service, broken: true do
  describe '.build' do
    it 'inits, using HTTParty' do
      expect(RetrieveProducts::RetrieveMedia).to receive(:new).with(HTTParty).and_call_original
      expect(RetrieveProducts::RetrieveMedia.build).to be_a(RetrieveProducts::RetrieveMedia)
    end
  end

  describe '#call' do
    let(:pi) { ProductItem.new mpxid: 'http://data.media2.theplatform.com/media/data/Media/373829661' }

    context 'remote', :vcr do
      it 'gets raw media' do
        result = RetrieveProducts::RetrieveMedia.build.call(pi)

        expect(result).to be_media_retrieved
        expect(result.raw).not_to be_blank
      end
    end

    it 'handles exception from HTTParty' do
      http = double
      allow(http).to receive(:get).and_raise('Error')

      result = RetrieveProducts::RetrieveMedia.new(http).call(pi)

      expect(result).not_to be_media_retrieved
      expect(result.error_message).not_to be_nil
    end
  end
end
