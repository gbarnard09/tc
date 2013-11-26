require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)



test "that creating a friendship works wthout raising an exception" do 
	assert_nothing_raised do
		UserFriendship.create user: users(:ashley), friend: users(:vodka)

		end
	end

test "that creating a friendship based on a user id and friend id works"	do

	UserFriendship.create user_id: users(:ashley).id, friend_id: users(:freebird).id

  end
end
