# USERS
User.destroy_all
Show.destroy_all
League.destroy_all
Contestant.destroy_all
Roster.destroy_all
Round.destroy_all
Episode.destroy_all
Score.destroy_all

last_month = DateTime.now - 31
one_week = DateTime.now + 7
two_weeks = DateTime.now + 14
three_weeks = DateTime.now + 21
one_month = DateTime.now + 31

user1 = User.create(:email => 'faiweiner@gmail.com', :username => 'faiweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken', :admin => true)
user2 = User.create(:email => 'eliweiner@gmail.com', :username => 'eliweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'password', :password_confirmation => 'password')
user3 = User.create(:email => 'user1@gmail.com', :username => 'username1', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user4 = User.create(:email => 'user2@gmail.com', :username => 'username2', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user5 = User.create(:email => 'user3@gmail.com', :username => 'username3', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user6 = User.create(:email => 'user4@gmail.com', :username => 'username4', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')

show1 = Show.create(:name => 'The Bachelor', :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.', :image => '/assets/the_bachelor/logo.jpg', :episode_count => 10)
show2 = Show.create(:name => 'The Bachelorette', :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Repellat perspiciatis sequi culpa tempora et reprehenderit dolores, amet quos fugit numquam veritatis cupiditate fuga possimus ab sit alias, sunt, vitae. Iure.', :image => '/assets/the_bachelorette/logo.png', :episode_count => 10)
show3 = Show.create(:name => 'The Challenge', :premiere_date => three_weeks, :finale_date => three_weeks - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ratione voluptatum similique nihil quo excepturi eveniet modi. Fuga quaerat dolorum quidem itaque autem corporis, ratione eligendi, fugiat at sunt qui alias.', :image => '/assets/the_challenge/rivals_logo.jpg', :episode_count => 10)
show4 = Show.create(:name => 'The Voice', :premiere_date => one_month, :finale_date => one_month - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. A ipsam illum eos accusantium ad doloribus porro, pariatur sed. Libero magni debitis culpa natus, illum ex ut facilis vel qui. Voluptatibus.', :image => '/assets/the_voice/logo.jpg', :episode_count => 10)
show5 = Show.create(:name => 'The Bachelor Pad', :premiere_date => one_week, :finale_date => one_week - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum laudantium iure, iusto doloremque odit delectus tempora molestiae eos soluta, voluptatum expedita ipsum ut quod eius non minus placeat vel! Sit.', :image => '/assets/bachelor_pad/logo.jpg', :episode_count => 10)
show6 = Show.create(:name => 'Master Chef', :premiere_date => last_month, :finale_date => last_month - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maiores animi id repudiandae alias expedita, nisi aspernatur vel natus quam, recusandae sint assumenda mollitia qui culpa at delectus harum explicabo totam!', :image => '/assets/master_chef/logo.png', :episode_count => 10)
show7 = Show.create(:name => 'The Bachelor: Sean Lowe', :premiere_date => '01/07/2013', :finale_date => '01/12/2013', :description	=> 'The best bachelor ever - Sean Lowe is the man!', :image => '/assets/the_bachelor/logo.jpg', :episode_count => 10, :expired => true)

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :show_id => show3.id, :draft_type => 'Fantasy', :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :show_id => show3.id, :draft_type => 'Fantasy', :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :show_id => show1.id, :draft_type => 'Fantasy', :public_access => false)
league4 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :show_id => show7.id, :draft_type => 'Fantasy', :public_access => false, :expired => true)

league1.users << [user1, user2, user3]
league2.users << [user3, user4, user5]
league3.users << [user1, user4, user5]
league4.users << [user1, user2]

cont1 = Contestant.create(:name => 'Layla', :show_id => show1.id, :age => 22, :gender => 'Female', :occupation => 'Physical Therapist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis ullam doloribus, laborum asperiores aperiam.', :image => '/assets/the_bachelor/layla.jpg')
cont2 = Contestant.create(:name => 'Nikki', :show_id => show1.id, :age => 24, :gender => 'Female', :occupation => 'Executive Assistant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Id quas sunt quam autem, itaque ducimus perferendis optio sint molestiae.', :image => '/assets/the_bachelor/nikki.jpg')
cont3 = Contestant.create(:name => 'Jessica', :show_id => show1.id, :age => 32, :gender => 'Female', :occupation => 'Nurse', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique cum repudiandae quod officia expedita tenetur praesentium magnam.', :image => '/assets/the_bachelor/jessica.jpg')
cont4 = Contestant.create(:name => 'Heather', :show_id => show1.id, :age => 26, :gender => 'Female', :occupation => 'Hair Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/heather.jpg')
cont5 = Contestant.create(:name => 'Alex', :show_id => show1.id, :age => 24, :gender => 'Female', :occupation => 'Entrepreneur', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/alex.jpg')
cont6 = Contestant.create(:name => 'Suzie', :show_id => show1.id, :age => 24, :gender => 'Female', :occupation => 'Web Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/suzie.jpg')

cont7 = Contestant.create(:name => 'Catherine', :show_id => show7.id, :age => 26, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont8 = Contestant.create(:name => 'Lindsay', :show_id => show7.id, :age => 24, :gender => 'Female', :occupation => 'Substitute Teacher', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont9 = Contestant.create(:name => 'AshLee', :show_id => show7.id, :age => 32, :gender => 'Female', :occupation => 'Personal Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont10 = Contestant.create(:name => 'Desiree', :show_id => show7.id, :age => 26, :gender => 'Female', :occupation => 'Bridal Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont11 = Contestant.create(:name => 'Lesley M.', :show_id => show7.id, :age => 24, :gender => 'Female', :occupation => 'Political Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont12 = Contestant.create(:name => 'Tierra', :show_id => show7.id, :age => 24, :gender => 'Female', :occupation => 'Leasing Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont13 = Contestant.create(:name => 'Daniella', :show_id => show7.id, :age => 24, :gender => 'Female', :occupation => 'Commercial Casting Associate', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont14 = Contestant.create(:name => 'Selma', :show_id => show7.id, :age => 29, :gender => 'Female', :occupation => 'Real Estate Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont15 = Contestant.create(:name => 'Sarah', :show_id => show7.id, :age => 26, :gender => 'Female', :occupation => 'Advertising Executive', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont16 = Contestant.create(:name => 'Robyn', :show_id => show7.id, :age => 24, :gender => 'Female', :occupation => 'Oil Field Account Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont17 = Contestant.create(:name => 'Jackie', :show_id => show7.id, :age => 25, :gender => 'Female', :occupation => 'Cosmetics Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont18 = Contestant.create(:name => 'Amanda', :show_id => show7.id, :age => 28, :gender => 'Female', :occupation => 'Fit Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont19 = Contestant.create(:name => 'Leslie H.', :show_id => show7.id, :age => 26, :gender => 'Female', :occupation => 'Poker Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont20 = Contestant.create(:name => 'Kristy', :show_id => show7.id, :age => 26, :gender => 'Female', :occupation => 'Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont21 = Contestant.create(:name => 'Taryn', :show_id => show7.id, :age => 30, :gender => 'Female', :occupation => 'Health Club Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont22 = Contestant.create(:name => 'Kacie', :show_id => show7.id, :age => 25, :gender => 'Female', :occupation => 'Community Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont23 = Contestant.create(:name => 'Brooke', :show_id => show7.id, :age => 25, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont24 = Contestant.create(:name => 'Diana', :show_id => show7.id, :age => 31, :gender => 'Female', :occupation => 'Salon Owner', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')
cont25 = Contestant.create(:name => 'Katie', :show_id => show7.id, :age => 27, :gender => 'Female', :occupation => 'Yoga Instructor', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!')

roster1 = Roster.create(:user_id => user1.id, :league_id => league3.id)
roster2 = Roster.create(:user_id => user4.id, :league_id => league3.id)
roster3 = Roster.create(:user_id => user5.id, :league_id => league3.id)
roster4 = Roster.create(:user_id => user3.id, :league_id => league2.id)
roster5 = Roster.create(:user_id => user4.id, :league_id => league2.id)
roster6 = Roster.create(:user_id => user5.id, :league_id => league2.id)
roster7 = Roster.create(:user_id => user1.id, :league_id => league1.id)
roster8 = Roster.create(:user_id => user2.id, :league_id => league1.id)
roster9 = Roster.create(:user_id => user3.id, :league_id => league1.id)

roster10 = Roster.create(:user_id => user1.id, :league_id => league4.id)
roster11 = Roster.create(:user_id => user2.id, :league_id => league4.id)
roster10.contestants << [cont7, cont17, cont20, cont25, cont9, cont11]
roster11.contestants << [cont8, cont10, cont13, cont19, cont20, cont25]

# Roster for Edelman's Bachelor League (The Bachelor)
roster1.contestants << [cont1, cont2, cont3, cont4]
roster2.contestants << [cont2, cont3, cont4, cont5]
roster3.contestants << [cont3, cont4, cont5, cont6]

episode1 = Episode.create(:show_id => show7.id, :air_date => '07/01/2013')
episode2 = Episode.create(:show_id => show7.id, :air_date => '14/01/2013')
episode3 = Episode.create(:show_id => show7.id, :air_date => '21/01/2013')
episode4 = Episode.create(:show_id => show7.id, :air_date => '28/01/2013')
episode5 = Episode.create(:show_id => show7.id, :air_date => '04/02/2013')
episode6 = Episode.create(:show_id => show7.id, :air_date => '05/02/2013')
episode7 = Episode.create(:show_id => show7.id, :air_date => '11/02/2013')
episode8 = Episode.create(:show_id => show7.id, :air_date => '18/02/2013')
episode9 = Episode.create(:show_id => show7.id, :air_date => '25/02/2013')
episode10 = Episode.create(:show_id => show7.id, :air_date => '11/03/2013')

round1 = Round.create(:league_id => league4.id, :episode_id => episode1.id)
round2 = Round.create(:league_id => league4.id, :episode_id => episode2.id)
round3 = Round.create(:league_id => league4.id, :episode_id => episode3.id)
round4 = Round.create(:league_id => league4.id, :episode_id => episode4.id)
round5 = Round.create(:league_id => league4.id, :episode_id => episode5.id)
round6 = Round.create(:league_id => league4.id, :episode_id => episode6.id)
round7 = Round.create(:league_id => league4.id, :episode_id => episode7.id)
round8 = Round.create(:league_id => league4.id, :episode_id => episode8.id)
round9 = Round.create(:league_id => league4.id, :episode_id => episode9.id)
round10 = Round.create(:league_id => league4.id, :episode_id => episode10.id)

survival1 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 1', :points => 10)
survival2 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 2', :points => 20)
survival3 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 3', :points => 30)
survival4 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 4', :points => 40)
survival5 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 5', :points => 50)
survival6 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 6', :points => 60)
survival7 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 7', :points => 70)
survival8 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 8', :points => 80)
survival9 = Survival.create(:show_id => show7.id, :event => 'Contestant receives a rose in Week 9', :points => 90)
survival10 = Survival.create(:show_id => show7.id, :event => 'Contestant receives the final rose', :points => 100)

