module Snapcat
  class Friend
    ALLOWED_FIELD_CONVERSIONS = {
      can_see_custom_stories: :can_see_custom_stories,
      display: :display_name,
      name: :username,
      type: :type
    }

    attr_reader *ALLOWED_FIELD_CONVERSIONS.values
    attr_reader :story_data, :stories

    def initialize(data = {})
      humanize_data(data)
      @type = Type.new(@type)
      @stories = []
    end
    
    def story_data=(data)
      set_stories(data)
      @story_data = data
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
    
    def set_stories(friend_stories)
      @stories = []
      friend_stories[:stories].each do |story|
        stories << Story.new(story)
      end
    end

    class Type
      CONFIRMED = 0
      UNCONFIRMED = 1
      BLOCKED = 2
      DELETED = 3

      attr_reader :code

      def initialize(code)
        @code = code
      end

      def blocked?
        @code == BLOCKED
      end

      def confirmed?
        @code == CONFIRMED
      end

      def deleted?
        @code == DELETED
      end

      def unconfirmed?
        @code == UNCONFIRMED
      end
    end
  end
end
