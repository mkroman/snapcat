module Snapcat
  module Crypt
    extend self

    CIPHER = 'AES-128-ECB'
    STORY_CIPHER = 'AES-256-CBC'
    ENCRYPTION_KEY = 'M02cnQ51Ji97vwT4'

    def decrypt(data)
      cipher = OpenSSL::Cipher.new(CIPHER)
      cipher.decrypt
      cipher.key = ENCRYPTION_KEY
      decrypted_data = ''

      data.bytes.each_slice(16) do |slice|
        decrypted_data += cipher.update(slice.map(&:chr).join)
      end

      decrypted_data += cipher.final
    end
    
    def decrypt_story(data, key, iv)
      cipher = OpenSSL::Cipher.new(STORY_CIPHER)
      cipher.decrypt
      cipher.padding = 0
      cipher.key = Base64.decode64(key)
      cipher.iv = Base64.decode64(iv)
      decrypted_data = ''
      
      data.bytes.each_slice(16) do |slice|
        decrypted_data += cipher.update(slice.map(&:chr).join)
      end
      
      decrypted_data += cipher.final
    end

    def encrypt(data)
      cipher = OpenSSL::Cipher.new(CIPHER)
      cipher.encrypt
      cipher.key = ENCRYPTION_KEY
      cipher.update(pkcs5_pad(data)) + cipher.final
    end

    private

    def pkcs5_pad(data, blocksize = 16)
      pad = blocksize - (data.length % blocksize)
      "#{data}#{pad.chr * pad}"
    end
  end
end
