require 'spec_helper'

describe Snapcat::Friend do
  describe '.new' do
    it 'sets allowed fields' do
      friend = Snapcat::Friend.new(Fixture.friend_data)

      friend.can_see_custom_stories.must_equal true
      friend.display_name.must_equal 'John Smith'
      friend.username.must_equal 'jsmith10'
      friend.type.wont_equal nil
    end

    it 'sets type' do
      friend = Snapcat::Friend.new(Fixture.friend_data)

      friend.type.code.must_equal Fixture::FRIEND_TYPE
      friend.type.confirmed?.must_equal true
      friend.type.unconfirmed?.must_equal false
    end
  end
end
