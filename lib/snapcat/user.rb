module Snapcat
  class User
    module Privacy
      EVERYONE = 0
      FRIENDS = 1
    end

    attr_reader :data, :friends, :snaps_sent, :snaps_received

    def initialize
      @friends = []
      @snaps_sent = []
      @snaps_received = []
    end

    def data=(data)
      set_friends(data[:friends])
      set_snaps(data[:snaps])
      @data = data
    end

    private

    def set_friends(friends)
      @friends = []

      friends.each do |friend_data|
        @friends << Friend.new(friend_data)
      end
    end

    def set_snaps(snaps)
      @snaps_received = []
      @snaps_sent = []

      snaps.each do |snap_data|
        snap = Snap.new(snap_data)
        if snap.sent?
          @snaps_sent << snap
        else
          @snaps_received << snap
        end
      end
    end
  end
end
