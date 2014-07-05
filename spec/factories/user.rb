FactoryGirl.define do 
	factory :user, class:User do				
		password							'password'
		password_confirmation 'password'
		email									'user@example.com'		
	end
end
