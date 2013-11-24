require 'test_helper'

class UserTest < ActiveSupport::TestCase
 	test "a user should enter a first name" do 
 		user = User.new
 		assert !user.save
 		assert !user.errors[:first_name].empty?
 		
 	end

 		test "a user should enter a last name" do 
 		user = User.new
 		assert !user.save
 		assert !user.errors[:last_name].empty?
 		
 	end

 		test "a user should enter a profile name" do 
 		user = User.new
 		assert !user.save
 		assert !user.errors[:profile_name].empty?
 	end	

 	test "a user should have a unique profile name" do
 		user = User.new
 		user.profile_name = users(:ashley).profile_name
 		assert !user.save
 		assert !user.errors[:profile_name].empty?	

 		
 	end


 	test "a user should have a name wthout spaces" do
 		user = User.new(first_name: 'Glenn', last_name: 'Barnard', email:'gebarnard2@gmail.com')
		user.password = user.password_confirmation = 'passwordnew'	
 		

 		user.profile_name = "My Profile with Spaces"

 		assert !user.save
 		assert !user.errors[:profile_name].empty?
 		assert user.errors[:profile_name].include?("Must be formatted correctly.") 

 	end

	test "a user can have a correctly formatted profile name" do
		user = User.new(first_name: 'Glenn', last_name: 'Barnard', email:'gebarnard2@gmail.com')
		user.password = user.password_confirmation = 'passwordnew'	

		user.profile_name = 'gebarnard_2'
		assert user.valid?
	end

end