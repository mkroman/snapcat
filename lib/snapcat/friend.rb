module Snapcat
  class Friend
    ALLOWED_FIELD_CONVERSIONS = {
      can_see_custom_stories: :can_see_custom_stories,
      display: :display_name,
      name: :username,
      type: :type
    }

    attr_reader *ALLOWED_FIELD_CONVERSIONS.values

    def initialize(data = {})
      humanize_data(data)
      @type = Type.new(@type)
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
