# USERS
User.destroy_all
Show.destroy_all
League.destroy_all

user1 = User.create(:email => 'faiweiner@gmail.com', :username => 'faiweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user2 = User.create(:email => 'ncharoonsri@gmail.com', :username => 'faiball', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user3 = User.create(:email => 'user1@gmail.com', :username => 'username1', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user4 = User.create(:email => 'user2@gmail.com', :username => 'username2', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user5 = User.create(:email => 'user3@gmail.com', :username => 'username3', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')

show1 = Show.create(:name => 'The Bachelor', :premiere_date => '14/03/06', :draft_close_date => '14/03/06')
show2 = Show.create(:name => 'The Bachelorette', :premiere_date => '14/03/02', :draft_close_date => '14/03/02')
show3 = Show.create(:name => 'The Challenge', :premiere_date => '14/03/02', :draft_close_date => '14/03/02')
show4 = Show.create(:name => 'The Voice', :premiere_date => '14/03/02', :draft_close_date => '14/03/02')

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :show_id => show3.id, :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :show_id => show3.id, :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :show_id => show1.id, :public_access => false)

league1.users << [user1, user2, user3]
league2.users << [user3, user4, user5]
league3.users << [user1, user4, user5]