module Snapcat
  class Requestor
    include HTTMultiParty

    SECRET = 'iEk21fuwZApXlz93750dmW22pw389dPwOk'
    STATIC_TOKEN = 'm198sOkJEn37DjqZ32lpRu76xmw288xSQ9'
    HASH_PATTERN = '0001110111101110001111010101111011010001001110011000110001000110'

    attr_accessor :auth_token

    base_uri 'https://feelinsonice-hrd.appspot.com/bq/'

    def initialize(username)
      @auth_token = STATIC_TOKEN
      @username = username
    end

    def request(endpoint, data = {})
      response = self.class.post(
        "/#{endpoint}",
        body: merge_defaults_with(data),
        headers: request_headers
      )

      additional_fields = additional_fields_for(data)
      result = Response.new(response, additional_fields)

      auth_token_from(result, endpoint)
      result
    end

    def request_media(snap_id)
      response = self.class.post(
        '/blob',
        body: merge_defaults_with({ id: snap_id, username: @username }),
        headers: request_headers
      )

      Response.new(response)
    end

    def request_with_username(endpoint, data = {})
      request(endpoint, data.merge({ username: @username }))
    end

    def request_upload(data, type = nil)
      encrypted_data = Crypt.encrypt(data)
      media = Media.new(encrypted_data, type)
      file_extension = media.file_extension

      begin
        file = Tempfile.new(['snap', ".#{file_extension}"])
        file.write(encrypted_data.force_encoding('utf-8'))
        file.rewind

        return request_with_username(
          'upload',
          data: file,
          media_id: media.generate_id(@username),
          type: media.type_code
        )
      ensure
        file.close
        file.unlink
      end
    end

    def request_upload_story(data, time = nil, caption_text = nil, type = nil)
      encrypted_data = Crypt.encrypt(data)
      media = Media.new(encrypted_data, type)
      file_extension = media.file_extension

      begin
        file = Tempfile.new(['story', ".#{file_extension}"])
        file.write(encrypted_data.force_encoding('utf-8'))
        file.rewind

        return request_with_username(
          'retry_post_story',
          data: file,
          media_id: media.generate_id(@username),
          client_id: media.generate_id(@username),
          time: time || 3,
          caption_text_display: caption_text,
          type: media.type_code
        )
      ensure
        file.close
        file.unlink
      end
    end

    private

    def additional_fields_for(data)
      if data[:media_id]
        { media_id: data[:media_id] }
      else
        {}
      end
    end

    def auth_token_from(result, endpoint)
      if endpoint == 'logout'
        @auth_token = STATIC_TOKEN
      else
        @auth_token = result.auth_token || @auth_token
      end
    end

    def built_token(auth_token, timestamp)
      hash_a = Digest::SHA256.new << "#{SECRET}#{auth_token}"
      hash_b = Digest::SHA256.new << "#{timestamp}#{SECRET}"

      HASH_PATTERN.split(//).each_index.inject('') do |final_string, index|
        if HASH_PATTERN[index] == '1'
          final_string << hash_b.to_s[index].to_s
        else
          final_string << hash_a.to_s[index].to_s
        end
      end
    end

    def merge_defaults_with(data)
      now = Timestamp.micro

      data.merge!({
        req_token: built_token(@auth_token, now),
        timestamp: now
      })
    end

    def request_headers
      {'User-Agent' => 'Snapchat/8.1.1 (iPhone; iOS 8.1.1; gzip)',
       'Accept-Language' => 'en',
       'Accept-Locale' => 'en'}
    end
  end
end
