module Snapcat
  class Story
    ALLOWED_FIELD_CONVERSIONS = {
      id: :id,
      username: :username,
      mature_content: :mature_content,
      client_id: :client_id,
      timestamp: :timestamp,
      media_id: :media_id,
      media_key: :media_key,
      media_iv: :media_iv,
      media_url: :media_url,
      thumbnail_iv: :thumbnail_iv,
      thumbnail_url: :thumbnail_url,
      media_type: :media_type,
      time: :time,
      caption_text_display: :caption_text_display,
      zipped: :zipped,
      time_left: :time_left,
      is_shared: :is_shared
    }

    attr_reader *ALLOWED_FIELD_CONVERSIONS.values

    def initialize(data = {})
      humanize_data(data[:story])
      @viewed = data[:viewed]
      @media_type = Media::Type.new(code: @media_type)
    end
    
    def shared?
      @is_shared == true
    end
    
    def viewed?
      @viewed
    end
    
    def zipped?
      @zipped
    end

    private

    def humanize_data(data)
      ALLOWED_FIELD_CONVERSIONS.each do |api_field, human_field|
        instance_variable_set(
          "@#{human_field}",
          data[human_field] || data[api_field]
        )
      end
    end

  end
end
