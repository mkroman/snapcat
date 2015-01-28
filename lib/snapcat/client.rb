module Snapcat
  class Client
    attr_reader :user

    def initialize(username)
      @user = User.new
      @requestor = Requestor.new(username)
    end

    def auth_token
      @requestor.auth_token
    end

    def auth_token=(auth_token)
      @requestor.auth_token = auth_token
    end

    def block(username)
      @requestor.request_with_username(
        'friend',
        action: 'block',
        friend: username
      )
    end

    def clear_feed
      @requestor.request_with_username('clear')
    end

    def fetch_updates(update_timestamp = 0)
      set_user_data_with(@requestor.request_with_username(
        'updates',
        update_timestamp: update_timestamp
      ))
    end

    def get_stories
      set_user_story_data_with(@requestor.request_with_username('stories'))
    end

    def media_for(snap_id)
      @requestor.request_media(snap_id)
    end
    
    def media_for_story(story)
      @requestor.request_story_media(story)
    end
    
    def media_for_story_thumbnail(story)
      @requestor.request_story_media(story, 'thumbnail')
    end

    def delete_friend(username)
      @requestor.request_with_username(
        'friend',
        action: 'delete',
        friend: username
      )
    end

    def add_friend(username)
      @requestor.request_with_username(
        'friend',
        action: 'add',
        friend: username
      )
    end

    def set_display_name(username, display_name)
      @requestor.request_with_username(
        'friend',
        action: 'display',
        display: display_name,
        friend: username
      )
    end

    def login(password)
      set_user_data_with(
        @requestor.request_with_username('login', password: password)
      )
    end

    def logout
      @requestor.request_with_username('logout')
    end

    def register(password, birthday, email)
      result = @requestor.request(
        'register',
        birthday: birthday,
        email: email,
        password: password
      )
      unless result.success?
        return result
      end

      result_two = @requestor.request_with_username(
        'registeru',
        email: email
      )

      set_user_data_with(result_two)
    end

    def screenshot(snap_id, view_duration = 1)
      snap_data = {
        snap_id => {
          c: Snap::Status::SCREENSHOT,
          sv: view_duration,
          t: Timestamp.float
        }
      }
      events = [
        {
          eventName: 'SNAP_SCREENSHOT',
          params: { id: snap_id },
          ts: Timestamp.macro - view_duration
        }
      ]

      @requestor.request_with_username(
        'update_snaps',
        events: events.to_json,
        json: snap_data.to_json
      )
    end

    def send_media(data, recipients, options = {})
      result = @requestor.request_upload(data, options[:type])

      unless result.success?
        return result
      end

      media_id = result.data[:media_id]

      @requestor.request_with_username(
        'send',
        media_id: media_id,
        recipient: prepare_recipients(recipients),
        time: options[:view_duration] || 3
      )
    end

    def send_story(data, options = {})
      @requestor.request_upload_story(data, options[:time], options[:caption_text], options[:type])
    end

    def unblock(username)
      @requestor.request_with_username(
        'friend',
        action: 'unblock',
        friend: username
      )
    end

    def view(snap_id, view_duration = 1)
      snap_data = {
        snap_id => { t: Timestamp.float, sv: view_duration }
      }
      events = [
        {
          eventName: 'SNAP_VIEW',
          params: { id: snap_id },
          ts: Timestamp.macro - view_duration
        },
        {
          eventName: 'SNAP_EXPIRED',
          params: { id: snap_id },
          ts: Timestamp.macro
        }
      ]

      @requestor.request_with_username(
        'update_snaps',
        events: events.to_json,
        json: snap_data.to_json
      )
    end

    def update_email(email)
      @requestor.request_with_username(
        'settings',
        action: 'updateEmail',
        email: email
      )
    end

    def update_privacy(code)
      @requestor.request_with_username(
        'settings',
        action: 'updatePrivacy',
        privacySetting: code
      )
    end

    private

    def prepare_recipients(recipients)
      if recipients.is_a? Array
        recipients.join(',')
      else
        recipients
      end
    end

    def request_events(events, snap_data)
      @requestor.request_with_username(
        'update_snaps',
        events: events,
        json: snap_data
      )
    end

    def set_user_data_with(result)
      if result.success?
        @user.data = result.data
      end

      result
    end
    
    def set_user_story_data_with(result)
      if result.success?
        @user.story_data = result.data
      end
      
      result
    end
  end
end
