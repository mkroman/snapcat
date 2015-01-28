module Snapcat
  class User
    module Privacy
      EVERYONE = 0
      FRIENDS = 1
    end

    attr_reader :data, :story_data, :friends, :snaps_sent, :snaps_received, :stories_sent, :stories_received

    def initialize
      @friends = []
      @snaps_sent = []
      @snaps_received = []
      @stories_sent = []
      @stories_received = []
    end

    def data=(data)
      set_friends(data[:friends])
      set_snaps(data[:snaps])
      @data = data
    end
    
    def story_data=(data)
      set_stories(data)
      @story_data = data
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
    
    def set_stories(stories)
      set_my_stories(stories[:my_stories])
      set_friend_stories(stories[:friend_stories])
    end
    
    def set_my_stories(stories)
      @stories_sent = []
      stories.each do |story_data|
        @stories_sent << Story.new(story_data)
      end
    end
    
    def set_friend_stories(stories)
      @stories_received = []
      stories.each do |user_story_data|
        
        @friends.find do |friend|
          friend.story_data = user_story_data if friend.username == user_story_data[:username]
        end
        
        user_story_data[:stories].each do |story_data|
          @stories_received << Story.new(story_data)
        end
        
      end
    end
    
  end
end
