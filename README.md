Snapcat
=======
[![Build Status](https://travis-ci.org/nneal/snapcat.png)](https://travis-ci.org/nneal/snapcat)


A cat-tastic Ruby wrapper for the [Snapchat](http://snapchat.com) private API.
Meow. This gem is designed to give you a friendly Ruby-like interface for
interacting with the Snapchat API.


Installation
------------

Add this line to your application's `Gemfile`:

    gem 'snapcat', '~> 0.7'

And then execute:

    $ bundle

Alternatively, install it via command line:

    $ gem install snapcat


Usage
-----

**User Auth**

```ruby
# Initialize a client and login
snapcat = Snapcat::Client.new('your-username')
snapcat.login('topsecretpassword')

# Initialize a new client, register, and login
snapcat = Snapcat::Client.new('your-new-username')
snapcat.register('topsecretpassword', '1990-01-20', 'test@example.com')

# Logout
snapcat.logout
```

**Responses**

```ruby
# Every call to the API responds with Snapcat::Response object with which you can check a few important things
response = snapcat.block('username-to-block')
response.code # => 200
response.http_success # => true
response.data # => { logged: true, ... }
```

**User Actions**

```ruby
# Clear feed
snapcat.clear_feed

# Fetch a user's updates
snapcat.fetch_updates

# Block a user
snapcat.block('username-to-block')

# Unblock a user
snapcat.unblock('username-to-unlock')

# Update user's email
snapcat.update_email('newemail@example.com')

# Update user's privacy setting
# Two choices:
#   Snapcat::User::Privacy::EVERYONE
#   Snapcat::User::Privacy::FRIENDS
snapcat.update_privacy(Snapcat::User::Privacy::EVERYONE)
```

**User**

```ruby
# Get the user
user = snapcat.user

# Raw user data
user.data

# Raw story data
user.story_data

# Snaps received
user.snaps_received

# Snaps sent
user.snaps_sent

# Stories received
user.stories_received

# Stories you sent
user.stories_sent

# Friends list (includes users for snapchat shared stories)
user.friends
```

**Friends**

```ruby
# Add a new friend
snapcat.add_friend('mybestbuddy')

# Delete a friend :(
snapcat.delete_friend(friend.username)

# Get a friend
friend = user.friends.first

# Raw story data
friend.story_data

# Stories from this friend
friend.stories

# Set a friend's display name
snapcat.set_display_name(friend.username, 'Nik Ro')

# What kind of friend are they anyway??
friend.type
friend.type.confirmed?
friend.type.unconfirmed?
friend.type.blocked?
friend.type.deleted?

# Friend Information
friend.can_see_custom_stories
friend.display_name
friend.username
```

**Snap**

```ruby
# Grab a snap
snap = user.snaps_received.first

# Record a view
snapcat.view(snap.id)

# Record a screenshot
snapcat.screenshot(snap.id)

# Snap Information
snap.broadcast
snap.broadcast_action_text
snap.broadcast_hide_timer
snap.broadcast_url
snap.id
snap.media_id
snap.media_type
snap.opened
snap.recipient
snap.screenshot_count
snap.sender
snap.status
snap.sent
snap.zipped?
```

**Story**

```ruby
# Grab story data (Story information is all blank before this is called)
snapcat.get_stories

# Get a story from all of your stories
story = user.stories_received.first

# Or get a story from a specific friend
story = friend.stories.first

# If a story is shared, it's automatically added and populated by SnapChat
story.shared?

# Story Information
story.caption_text_display
story.client_id
story.id
story.username
story.mature_content
story.media_key
story.media_id
story.media_iv
story.media_type
story.media_url
story.thumbnail_url
story.thumbnail_iv
story.time
story.time_left
story.timestamp
story.viewed?
story.zipped?
```

**Media**

```ruby
# Get the snap image or video data
media_response = snapcat.media_for(snap.id)
media = media_response.data[:media]

# Or the story image or video data
media_response = snapcat.media_for_story(story)
media = media_response.data[:media]

# Get the data from the media object
media.to_s

# Media Information
media.file_extension
media.image?
media.type_code
media.video?
media.zipped?
```

**Sending**

```ruby
# Read an mp4 or jpg to a string
data = File.open("/foo/bar/file.jpg", "rb") {|f| f.read}

# Send it to catsaregreat with 3 seconds duration
snapcat.send_media(data, 'catsaregreat')

# Or send it to multiple recipients and override default view_duration
snapcat.send_media(data, %w(catsaregreat ronnie99), view_duration: 4)

# Or post it to your story
snapcat.send_story(data, caption_text: "oh hai haz cheezburger", time: 10)
```

**Advanced User Auth**

The standard `login` method will log out all other sessions. If you want to use
Snapcat in multiple concurrent processes, you need to share this token across
processes and set it manually.

```ruby
# Fetch token
snapcat.auth_token

# Set token
snapcat.auth_token = '1c7e8f83-1379-4694-8fa9-4cab6b73f0d4'
```


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Add tests and make sure they pass
6. Create new Pull Request


Credits
-------

* [Neal Kemp](http://nealke.mp), [Daniel Archer](http://dja.io)
* Based on work by martinp on [pysnap](https://github.com/martinp/pysnap) and by
  djstelles on [php-snapchat](https://github.com/dstelljes/php-snapchat)

Copyright &copy; 2013 Neal Kemp, Daniel Archer

Released under the MIT License, which can be found in the repository in `LICENSE.txt`.
