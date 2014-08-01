module Snapcat
  class Media
    def initialize(data, type_code = nil)
      @data = Crypt.decrypt(data)
      @type = Type.new(code: type_code, data: @data)
    end

    def file_extension
      @type.file_extension
    end

    def image?
      @type.image?
    end

    def generate_id(username)
      "#{username.upcase}~#{Timestamp.macro}"
    end

    def to_s
      @data
    end

    def type_code
      @type.code
    end

    def video?
      @type.video?
    end

    class Type
      IMAGE = 0
      VIDEO = 1
      VIDEO_NOAUDIO = 2
      FRIEND_REQUEST = 3
      FRIEND_REQUEST_IMAGE = 4
      FRIEND_REQUEST_VIDEO = 5
      FRIEND_REQUEST_VIDEO_NOAUDIO = 6

      attr_reader :code

      def initialize(options = {})
        @code = code_from(options[:code], options[:data])
      end

      def file_extension
        if image?
          'jpg'
        elsif video?
          'mp4'
        end
      end

      def image?
        [IMAGE, FRIEND_REQUEST_IMAGE].include? @code
      end

      def video?
        [
          VIDEO, VIDEO_NOAUDIO, FRIEND_REQUEST_VIDEO, FRIEND_REQUEST_VIDEO_NOAUDIO
        ].include? @code
      end

      private

      def code_from(code, data)
        if code
          code
        else
          code_from_data(data)
        end
      end

      def code_from_data(data)
        case data.to_s[0..1]
        when "\x00\x00".force_encoding('ASCII-8BIT')
          VIDEO
        when "\xFF\xD8".force_encoding('ASCII-8BIT')
          IMAGE
        end
      end
    end
  end
end
