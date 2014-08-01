require 'spec_helper'

describe Snapcat::Media do
  describe '.new' do
    it 'decrypts data' do
      skip 'blocked by decryption in test'
      media = Snapcat::Media.new(encrypted_data)

      media.data.must_equal DataHelper.data_for(:decrypted)
    end
  end

  describe '#to_s' do
    it 'returns the decrypted data contained' do
      skip 'blocked by decryption in test'
      media = Snapcat::Media.new(encrypted_data(:image))

      media.to_s.must_equal DataHelper.data_for(:decrypted)
    end
  end

  describe '#image?' do
    context 'when it is an image' do
      it 'returns true' do
        media = Snapcat::Media.new(encrypted_data(:image))

        media.image?.must_equal true
      end
    end

    context 'when it is not an image' do
      it 'returns false' do
        media = Snapcat::Media.new(encrypted_data(:video))

        media.image?.must_equal false
      end
    end
  end

  describe '#video?' do
    context 'when it is a video' do
      it 'returns true' do
        media = Snapcat::Media.new(encrypted_data(:video))

        media.video?.must_equal true
      end
    end

    context 'when it is not a video' do
      it 'returns false' do
        media = Snapcat::Media.new(encrypted_data(:image))

        media.video?.must_equal false
      end
    end
  end

  def encrypted_data(type = :image)
    DataHelper.data_for(:encrypted, type)
  end
end
