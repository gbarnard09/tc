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
	assert users(:ashley).pending_friends.include?(users(:freebird))

  end

context "a new istance" do
	setup do
		@user_friendship = UserFriendship.new user: users(:ashley), friend: users(:freebird)
	end


	should "have a pending state" do
		assert_equal 'pending', @user_friendship.state
	end	
  end

 context "#send_request_email"	do
 	setup do
		@user_friendship = UserFriendship.create user: users(:ashley), friend: users(:freebird)
	end

	should "send an email" do
		assert_difference 'ActionMailer::Base.deliveries.size', 1 do
			@user_friendship.send_request_email
		end	
	end	
 end	


 context "#accept!" do
 	setup do
		@user_friendship = UserFriendship.create user: users(:ashley), friend: users(:freebird)
	end

	should "set the state to accepted" do
		@user_friendship.accept!
		assert_equal "accepted", @user_friendship.state
	end	

	should "send accepted email" do
		assert_difference 'ActionMailer::Base.deliveries.size', 1 do
			@user_friendship.accept!
		end	
	end

	should "include the friend in list of friends"	do
		@user_friendship.accept!
		users(:ashley).friends.reload
		assert users(:ashley).friends.include?(users(:freebird))
	
	end	
 end 

 	context ".request" do
 		should "create two user friendships"	do
 			assert_difference 'UserFriendship.count', 2  do
 				UserFriendship.request(users(:ashley), users(:freebird))
 			end	
 		end	

 	should "send a friend requested email" do
 		assert_difference 'ActionMailer::Base.deliveries.size', 1  do
 				UserFriendship.request(users(:ashley), users(:freebird))
 		end		
 	end	
 end	
end
