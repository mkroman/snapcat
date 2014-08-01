require 'spec_helper'

describe Snapcat::User do
  describe '#data=' do
    it 'sets friends' do
      user = Snapcat::User.new

      user.data = Fixture.user_data

      user.friends.count.must_equal 1
      user.friends.first.must_be_kind_of Snapcat::Friend
    end

    it 'sets snaps_received' do
      user = Snapcat::User.new

      user.data = Fixture.user_data

      user.snaps_received.count.must_equal 1
      user.snaps_received.first.must_be_kind_of Snapcat::Snap
    end

    it 'sets snaps_sent' do
      user = Snapcat::User.new

      user.data = Fixture.user_data

      user.snaps_sent.count.must_equal 1
      user.snaps_sent.first.must_be_kind_of Snapcat::Snap
    end

    it 'sets raw data' do
      user = Snapcat::User.new

      user.data = Fixture.user_data

      user.data.must_equal Fixture.user_data
    end
  end
end
