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

show1 = Show.create(:name => 'The Bachelor', :premiere_date => two_weeks, :draft_close_date => two_weeks - 5, :description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.')
show2 = Show.create(:name => 'The Bachelorette', :premiere_date => two_weeks, :draft_close_date => two_weeks - 5, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Repellat perspiciatis sequi culpa tempora et reprehenderit dolores, amet quos fugit numquam veritatis cupiditate fuga possimus ab sit alias, sunt, vitae. Iure.')
show3 = Show.create(:name => 'The Challenge', :premiere_date => three_weeks, :draft_close_date => three_weeks - 5, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ratione voluptatum similique nihil quo excepturi eveniet modi. Fuga quaerat dolorum quidem itaque autem corporis, ratione eligendi, fugiat at sunt qui alias.')
show4 = Show.create(:name => 'The Voice', :premiere_date => one_month, :draft_close_date => one_month - 5, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. A ipsam illum eos accusantium ad doloribus porro, pariatur sed. Libero magni debitis culpa natus, illum ex ut facilis vel qui. Voluptatibus.')
show5 = Show.create(:name => 'The Bachelor Pad', :premiere_date => one_week, :draft_close_date => one_week - 5, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum laudantium iure, iusto doloremque odit delectus tempora molestiae eos soluta, voluptatum expedita ipsum ut quod eius non minus placeat vel! Sit.')
show6 = Show.create(:name => 'Master Chef', :premiere_date => last_month, :draft_close_date => last_month - 5, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maiores animi id repudiandae alias expedita, nisi aspernatur vel natus quam, recusandae sint assumenda mollitia qui culpa at delectus harum explicabo totam!')

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :show_id => show3.id, :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :show_id => show3.id, :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :show_id => show1.id, :public_access => false)

league1.users << [user1, user2, user3]
league2.users << [user3, user4, user5]
league3.users << [user1, user4, user5]

cont1 = Contestant.create(:name => 'Layla', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Physical Therapist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis ullam doloribus, laborum asperiores aperiam, recusandae soluta est eum, accusantium delectus tempore voluptate reprehenderit repellat. Perspiciatis atque, obcaecati adipisci eos tempora.', :image => '/assets/the_bachelor/layla.jpg')
cont2 = Contestant.create(:name => 'Nikki', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Executive Assistant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Id quas sunt quam autem, itaque ducimus perferendis optio sint molestiae. Dolorem, laudantium eveniet. Earum possimus minus ex culpa error, quaerat aut!', :image => '/assets/the_bachelor/nikki.jpg')
cont3 = Contestant.create(:name => 'Jessica', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Nurse', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt totam iusto nulla dolorum modi nisi debitis ipsum quae blanditiis laudantium saepe, similique cum repudiandae quod officia expedita tenetur praesentium magnam.', :image => '/assets/the_bachelor/jessica.jpg')
cont4 = Contestant.create(:name => 'Heather', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Hair Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus praesentium corporis repellat, facere possimus, suscipit tempore! Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/heather.jpg')
cont5 = Contestant.create(:name => 'Alex', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Entrepreneur', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus praesentium corporis repellat, facere possimus, suscipit tempore! Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/alex.jpg')
cont6 = Contestant.create(:name => 'Suzie', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Web Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus praesentium corporis repellat, facere possimus, suscipit tempore! Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/suzie.jpg')

roster1 = Roster.create(user_id: user1.id, league_id: league3.id)
roster2 = Roster.create(user_id: user4.id, league_id: league3.id)
roster3 = Roster.create(user_id: user5.id, league_id: league3.id)
roster4 = Roster.create(user_id: user3.id, league_id: league2.id)
roster5 = Roster.create(user_id: user4.id, league_id: league2.id)
roster6 = Roster.create(user_id: user5.id, league_id: league2.id)
roster7 = Roster.create(user_id: user1.id, league_id: league1.id)
roster8 = Roster.create(user_id: user2.id, league_id: league1.id)
roster9 = Roster.create(user_id: user3.id, league_id: league1.id)

# Roster for Edelman's Bachelor League (The Bachelor)
roster1.contestants << [cont1, cont2, cont3, cont4]
roster2.contestants << [cont2, cont3, cont4, cont5]
roster3.contestants << [cont3, cont4, cont5, cont6]




