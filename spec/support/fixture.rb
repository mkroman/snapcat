module Fixture
  extend self

  BIRTHDAY = '1990-01-30'
  EMAIL = 'meow@meow.com'
  FRIEND_DISPLAY_NAME = 'Henrie McKitten'
  FRIEND_USERNAME = 'catsaregreat'
  FRIEND_TYPE = Snapcat::Friend::Type::CONFIRMED
  MEDIA_ID = 'ILUVKITTENS4~1384804683'
  PASSWORD = 'topsecret'
  RECIPIENT = 'ronnie99'
  RECIPIENTS = %w(ronnie99 jimbo2000)
  SNAP_ID = '519861384740350100r'
  USERNAME = 'iluvkittens'
  VIEW_DURATION = 6

  def friend_data
    {
      can_see_custom_stories: true,
      display: 'John Smith',
      name: 'jsmith10',
      type: FRIEND_TYPE
    }
  end

  def snap_data(status = :sent)
    {
      broadcast: 'broadcast',
      broadcast_action_text: 'broadcast_action_text',
      broadcast_hide_timer: 'broadcast_hide_timer',
      broadcast_url: 'broadcast_url',
      c: 'c',
      id: '39894406827280519r',
      m: 0,
      st: 1,
      sts: 1406840596,
      t: 6,
      ts: 1406840596
    }.merge(status_specific_snap_data(status))
  end

  def user_data
    {
      friends: [
        friend_data
      ],
      snaps: [
        snap_data(:sent),
        snap_data(:received)
      ]
    }
  end

  private

  def status_specific_snap_data(status)
    if status == :sent
      {
        c_id: 'some_media_id',
        rp: FRIEND_USERNAME,
        sn: USERNAME
      }
    else
      {
        rp: FRIEND_USERNAME,
        sn: USERNAME
      }
    end
  end
end
