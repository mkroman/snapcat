module Snapcat
  class Response
    RECOGNIZED_CONTENT_TYPES = %w(application/json application/octet-stream)
    attr_reader :code, :data, :http_success

    def initialize(response, additional_fields = {}, story = nil)
      @story = story
      @data = formatted_result(response).merge(additional_fields)
      @code = response.code
      @http_success = response.success?
    end

    def auth_token
      @data[:auth_token]
    end

    def success?
      if !@data[:logged].nil?
        !!@data[:logged]
      else
        @http_success
      end
    end

    private

    def format_recognized_content(content_type, content)
      if content_type.include? 'application/json'
        JSON.parse(content, symbolize_names: true)
      elsif !@story.nil? && content_type.include?('application/octet-stream')
        { media: Media.new(content, @story.media_type.code, @story) }
      elsif content_type.include? 'application/octet-stream'
        { media: Media.new(content) }
      end
    end

    def formatted_result(response)
      if !response_empty?(response) && recognized_content_type?(response.content_type)
        format_recognized_content(response.content_type, response.body)
      else
        {}
      end
    end

    def recognized_content_type?(content_type)
      RECOGNIZED_CONTENT_TYPES.detect do |recognized_content_type|
        content_type.include? recognized_content_type
      end
    end

    def response_empty?(response)
      response.body.to_s.empty?
    end
  end
end
