require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

	context "#index"  do
		context "when not logged in" do
			should "redirect to the login page" do
			get :index
			assert_response :redirect
			end	
		end



	context "when logged in" do
		setup do
			
		end	
	end	
	end	




	context "#new"  do
		context "when not logged in" do
			should "redirect to the login page" do
			get :new
			assert_response :redirect
			end	
		end
	
	context "when logged in" do	
		setup do
			sign_in users(:ashley)
		end

		should "get new and return success" do
			get :new
			assert_response :success
		end

		should "should set a flash error if the friend_id params is missing" do
			get :new, {}
			assert_equal "Friend required", flash[:error]
		end	


		should "display the friend's name" do
			get :new, friend_id: users(:vodka)
			assert_match /#{users(:vodka).full_name}/, response.body
		end	

		should "assign a new user friendship" do
			get :new, friend_id: users(:vodka)
			assert assigns(:user_friendship)
		end	

		should "assign a new user friendship to correct friend" do
			get :new, friend_id: users(:vodka)
			assert_equal users(:vodka), assigns(:user_friendship).friend
		end	

		should "assign a new user friendship to the currently logged in user" do
			get :new, friend_id: users(:vodka)
			assert_equal users(:ashley), assigns(:user_friendship).user
		end	

		should "returns a 404 status if no friend is found" do
			get :new, friend_id: 'invalid'
			assert_response :not_found
		end	

		should "ask if you really want to friend the user" do
			get :new, friend_id: users(:vodka)
			assert_match /Do you really want to friend #{users(:vodka).profile_name}?/, response.body
		end	
	end	
  end

  context "#create" do
  	context "when not logged in" do
  		should "redirect to the login page" do
  			get :new
  			assert_redirected_to login_path

  		end	
  	end	
  
  context "when logged in" do
  	setup do
  		sign_in users(:ashley)
  	end
  	
  	context "with no friend_id" do
  		setup do
  			post :create	
  		end	
  	

  		should "set the flash error message" do
  			assert !flash[:error].empty?
  		end	
	
		
  		should "redirect to the site root" do
  			assert_redirected_to root_path
  		end	
	  end	
	
	  context "with a valid friend_id" do
	  	setup do
	  		post :create, user_friendship: { friend_id: users(:freebird) }
	  	end
	  
	  	should "assign a friend object" do
	  		assert assigns(:friend)
	  		assert_equal users(:freebird), assigns(:friend)
	  	end	
	  
	  	should "assign a user_friendship object" do
	  		assert assigns(:user_friendship)
	  		assert_equal users(:ashley), assigns(:user_friendship).user
	  		assert_equal users(:freebird), assigns(:user_friendship).friend
	  	end	
	  
	  	should "create a friendship" do
	  		assert users(:ashley).pending_friends.include?(users(:freebird))
	  	end	
	  
	  	should "redirect to the profile page of the friend" do
	  		assert_response :redirect
	  		assert_redirected_to profile_path(users(:freebird))
	  	end	
	  
	  	should "set the flash success message" do
	  		assert flash[:success]
	  		assert_equal "You are now friends with #{users(:freebird).profile_name}", flash[:success]
	  	end	
	  end		
	end
  end	
end
