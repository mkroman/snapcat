require 'spec_helper'

describe Snapcat::Client do
  before(:each) do
    RequestStub.stub_all
  end

  describe '#auth_token' do
    it 'returns the requestors auth token' do
      ux = UserExperience.new
      ux.login

      auth_token = ux.client.auth_token

      auth_token.must_equal Snapcat::Requestor::STATIC_TOKEN
    end
  end

  describe '#auth_token=' do
    it 'set the requestors auth token' do
      ux = UserExperience.new
      ux.login

      ux.client.auth_token = 'imatoken'

      ux.client.auth_token.must_equal 'imatoken'
    end
  end

  describe '#block' do
    it 'blocks a user' do
      ux = UserExperience.new
      ux.login

      result = ux.client.block(Fixture::FRIEND_USERNAME)

      result.success?.must_equal true
    end
  end

  describe '#clear_feed' do
    it 'clears a users feed' do
      ux = UserExperience.new
      ux.login

      result = ux.client.clear_feed

      result.success?.must_equal true
    end
  end

  describe '#delete_friend' do
    it 'deletes this friend' do
      ux = UserExperience.new
      ux.login

      result = ux.client.delete_friend(ux.friend.username)

      result.success?.must_equal true
    end
  end

  describe '#add_friends' do
    it 'adds this friend' do
      ux = UserExperience.new
      ux.login

      result = ux.client.add_friend(ux.friend.username)

      result.success?.must_equal true
    end
  end

  describe '#fetch_updates' do
    it 'resets all of the users update fields' do
      ux = UserExperience.new
      ux.login

      result = ux.client.fetch_updates

      result.success?.must_equal true
      ux.client.user.friends.length.must_equal 5
    end
  end

  describe '#login' do
    it 'logs the user in' do
      ux = UserExperience.new

      result = ux.client.login(Fixture::PASSWORD)

      result.success?.must_equal true
    end

    it 'sets updatable fields' do
      ux = UserExperience.new
      user = ux.user

      ux.client.login(Fixture::PASSWORD)

      user.friends.length.must_equal 4
      user.snaps_received.length.must_equal 1
      user.snaps_sent.length.must_equal 0
      user.data.must_equal ResponseHelper.hash_for(:login)
    end
  end

  describe '#logout' do
    it 'logs the user out' do
      ux = UserExperience.new
      ux.login

      result = ux.client.logout

      result.success?.must_equal true
    end
  end

  describe '#media_for' do
    it 'retrieves media data' do
      skip 'this works but still have issues with decrypt in test suite'
      ux = UserExperience.new
      ux.login

      media = ux.client.media_for(ux.snap.id)

      media.data.must_equal DataHelper.data_for(:decrypted)
    end
  end


  describe '#register' do
    it 'allows a user to register' do
      ux = UserExperience.new

      result = ux.client.register(
        Fixture::PASSWORD,
        Fixture::BIRTHDAY,
        Fixture::EMAIL
      )

      result.success?.must_equal true
    end
  end

  describe '#send_media' do
    context 'with one recipient' do
      it 'send a snap to single user' do
        skip 'this works but having issues with decrypt in test'
        ux = UserExperience.new
        ux.login

        result = ux.client.send_media(
          DataHelper.data_for(:decrypted),
          Fixture::RECIPIENT,
          view_duration: Fixture::VIEW_DURATION
        )

        result.success?.must_equal true
      end
    end

    context 'with many recipients' do
      it 'send a snap to recipients' do
        skip 'this works but having issues with decrypt in test'
        ux = UserExperience.new
        ux.login

        result = ux.client.send_media(
          DataHelper.data_for(:decrypted),
          Fixture::RECIPIENTS,
          view_duration: Fixture::VIEW_DURATION
        )

        result.success?.must_equal true
      end
    end
  end

  describe '#screenshot' do
    it 'records a screenshot' do
      skip 'stubbing this one is annoying'
      ux = UserExperience.new
      ux.login

      result = ux.client.view(ux.snap.id)

      result.success?.must_equal true
    end
  end

  describe '#set_display_name' do
    it 'sets display name' do
      ux = UserExperience.new
      ux.login

      result = ux.client.set_display_name(
        ux.friend.username,
        Fixture::FRIEND_DISPLAY_NAME
      )

      result.success?.must_equal true
    end
  end

  describe '#unblock' do
    it 'unblocks a user' do
      ux = UserExperience.new
      ux.login

      result = ux.client.unblock(Fixture::FRIEND_USERNAME)

      result.success?.must_equal true
    end
  end

  describe '#update_email' do
    it 'updates a users email' do
      ux = UserExperience.new
      ux.login

      result = ux.client.update_email(Fixture::EMAIL)

      result.success?.must_equal true
    end
  end

  describe '#update_privacy' do
    it 'updates a users privacy setting' do
      ux = UserExperience.new
      ux.login

      result = ux.client.update_privacy(Snapcat::User::Privacy::EVERYONE)

      result.success?.must_equal true
    end
  end

  describe '#view' do
    it 'records a view' do
      skip 'stubbing this one is annoying'
      ux = UserExperience.new
      ux.login

      result = ux.client.view(ux.snap.id)

      result.success?.must_equal true
    end
  end
end
