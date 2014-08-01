module Fixture
  extend self

  BIRTHDAY = '1990-01-30'
  EMAIL = 'meow@meow.com'
  FRIEND_DISPLAY_NAME = 'Henrie McKitten'
  FRIEND_USERNAME = 'dja1o'
  FRIEND_TYPE = Snapcat::Friend::Type::CONFIRMED
  MEDIA_ID = 'DJA1O~1406840143'
  PASSWORD = 'password'
  RECIPIENT = 'goeric'
  RECIPIENTS = %w(goeric josh_archer)
  SNAP_ID = '39894406827280519r'
  USERNAME = 'dja1o'
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
