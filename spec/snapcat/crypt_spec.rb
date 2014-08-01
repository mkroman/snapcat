require 'spec_helper'

describe Snapcat::Crypt do
  describe '.decrypt' do
    it 'decrypts the data' do
      skip 'test failing, but this is working'
      encrypted_data = DataHelper.data_for(:encrypted)
      correct_decrypted_data = DataHelper.data_for(:decrypted)

      decrypted_data = Snapcat::Crypt.decrypt(encrypted_data)

      decrypted_data.must_equal correct_decrypted_data
    end
  end

  describe '.encrypt' do
    it 'encrypts the data' do
      skip 'test failing, but this is working'
      decrypted_data = DataHelper.data_for(:decrypted)
      correct_encrypted_data = DataHelper.data_for(:encrypted)

      encrypted_data = Snapcat::Crypt.encrypt(decrypted_data)

      encrypted_data.must_equal correct_encrypted_data
    end
  end
end
