# USERS
User.destroy_all
Show.destroy_all
League.destroy_all

last_month = DateTime.now - 31
one_week = DateTime.now + 7
two_weeks = DateTime.now + 14
three_weeks = DateTime.now + 21
one_month = DateTime.now + 31

user1 = User.create(:email => 'faiweiner@gmail.com', :username => 'faiweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user2 = User.create(:email => 'eliweiner@gmail.com', :username => 'eliweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'password', :password_confirmation => 'password')
user3 = User.create(:email => 'user1@gmail.com', :username => 'username1', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user4 = User.create(:email => 'user2@gmail.com', :username => 'username2', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user5 = User.create(:email => 'user3@gmail.com', :username => 'username3', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user6 = User.create(:email => 'user4@gmail.com', :username => 'username4', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')

show1 = Show.create(:name => 'The Bachelor', :premiere_date => two_weeks, :draft_close_date => two_weeks - 5)
show2 = Show.create(:name => 'The Bachelorette', :premiere_date => two_weeks, :draft_close_date => two_weeks - 5)
show3 = Show.create(:name => 'The Challenge', :premiere_date => three_weeks, :draft_close_date => three_weeks - 5)
show4 = Show.create(:name => 'The Voice', :premiere_date => one_month, :draft_close_date => one_month - 5)
show5 = Show.create(:name => 'The Bachelor Pad', :premiere_date => one_week, :draft_close_date => one_week - 5)
show6 = Show.create(:name => 'Master Chef', :premiere_date => last_month, :draft_close_date => last_month - 5)

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :show_id => show3.id, :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :show_id => show3.id, :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :show_id => show1.id, :public_access => false)

league1.users << [user1, user2, user3]
league2.users << [user3, user4, user5]
league3.users << [user1, user4, user5]

cont1 = Contestant.create(:name => 'Layla', :show_id => show1.id, :age => 22)
cont2 = Contestant.create(:name => 'Nikki', :show_id => show1.id, :age => 22)
cont3 = Contestant.create(:name => 'Jessica', :show_id => show1.id, :age => 22)
cont4 = Contestant.create(:name => 'Heather', :show_id => show1.id, :age => 22)









