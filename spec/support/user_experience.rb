class UserExperience
  attr_reader :client, :user

  def initialize
    @client = Snapcat::Client.new(Fixture::USERNAME)
    @user = @client.user
  end

  def friend
    @user.friends.find { |friend| friend.username == Fixture::FRIEND_USERNAME }
  end

  def login
    @client.login(Fixture::PASSWORD)
  end

  def snap
    @user.snaps_received.first
  end
end
