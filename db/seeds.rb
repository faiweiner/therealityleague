User.destroy_all
League.destroy_all
Roster.destroy_all
Round.destroy_all

Show.destroy_all
Event.destroy_all
Season.destroy_all
Episode.destroy_all
Contestant.destroy_all

Bracket.destroy_all
Fantasy.destroy_all

Scheme.destroy_all
Challenge.destroy_all
Extracurricular.destroy_all
Game.destroy_all
Survival.destroy_all

user1 = User.create(:email => 'faiweiner@gmail.com', :username => 'faiweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken', :admin => true)
user2 = User.create(:email => 'eliweiner@gmail.com', :username => 'eliweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'password', :password_confirmation => 'password')
user3 = User.create(:email => 'user1@gmail.com', :username => 'username1', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user4 = User.create(:email => 'user2@gmail.com', :username => 'username2', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user5 = User.create(:email => 'user3@gmail.com', :username => 'username3', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')
user6 = User.create(:email => 'user4@gmail.com', :username => 'username4', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken')

show1 = Show.create(:name => 'The Bachelor', :image => '/assets/the_bachelor/logo.jpg')
show2 = Show.create(:name => 'The Bachelorette', :image => '/assets/the_bachelorette/logo.png')
show3 = Show.create(:name => 'The Voice', :image => '/assets/the_voice/thevoice.jpg')
survivor = Show.create(:name => 'Survivor', :image => '/assets/survivor/29/logo.png')
show5 = Show.create(:name => 'The Challenge', :image => '/assets/the_challenge/thechallenge.jpg')

season1 = Season.create(
	:name => 'Juan Pablo', 
	:number => 18, 
	:show_id => show1.id, 
	:premiere_date => '05/01/2014',
	:finale_date => '10/03/2014', 
	:description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.', 
	:episode_count => 10, 
	:image => '/assets/the_bachelor/juanpablo.jpg', 
	:published => true)
season2 = Season.create(
	:name => 'Andi', 
	:number => 10, 
	:show_id => show2.id, 
	:premiere_date => '19/05/2014',
	:finale_date => '28/07/2014',
	:description => 'The tenth season of The Bachelorette features 26-year-old Andi Dorfman, an assistant district attorney from Atlanta, Georgia.',
	:episode_count => 10, 
	:image => 'http://a.abcnews.com/images/Entertainment/ht_andi_dorfman_bachelorette_sr_140319_16x9_992.jpg', 
	:published => true)
season3 = Season.create(
	:name => 'Sean Lowe', 
	:number => 17, 
	:show_id => show1.id, 
	:premiere_date => '01/07/2013', 
	:finale_date => '01/12/2013', 
	:description => 'The best bachelor ever - Sean Lowe is the man!', 
	:episode_count => 10, 
	:image => '/assets/the_bachelor/seanlowe.jpg', 
	:published => true,
	:expired => true)
season4 = Season.create(
	:name => 'Season 7', 
	:number => 7, 
	:show_id => show3.id, 
	:premiere_date => '23/09/2014', 
	:finale_date => '25/01/2015', 
	:description => 'This season with new judge Gwen Stefani', 
	:episode_count => 22, 
	:image => 'http://www.boomtron.com/wp-content/uploads/Voice-logo.jpg', 
	:published => true)
survivor29 = Season.create(
	:name => 'San Juan Del Sur - Blood vs. Water',
	:number => 29,
	:show_id => survivor.id,
	:premiere_date => '24/09/2014',
	:finale_date => '30/01/2015',
	:description => 'Similarly to Survivor: Blood vs. Water, the season features pairs of loved ones competing against each other but, unlike Blood vs. Water, all of the players are new',
	:episode_count => 10,
	:image => '/assets/survivor/29/logo.png',
	:published => false)

league1 = Fantasy.create(:name => 'The Best Public League', :commissioner_id => user1.id, :season_id => season2.id, :type => 'Fantasy', :public_access => true)
league2 = Fantasy.create(:name => 'The Super Private League', :commissioner_id => user2.id, :season_id => season2.id, :type => 'Fantasy', :public_access => false)
league3 = Fantasy.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season1.id, :type => 'Fantasy', :public_access => false)
league4 = Bracket.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season3.id, :type => 'Bracket', :public_access => false, :active => false)

league1.users << [user1, user2, user3]
league2.users << [user1, user3, user4, user5]
league3.users << [user1, user4, user5]
league4.users << [user1, user2]

cont1 = Contestant.create(
	:name => 'Cassandra', 
	:season_id => season1.id, 
	:age => 22, 
	:gender => 'Female', 
	:image => '/assets/the_bachelor/season19/cassandra.jpg',
	:occupation => 'Physical Therapist', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis ullam doloribus, laborum asperiores aperiam.')
cont2 = Contestant.create(
	:name => 'Nikki', 
	:season_id => season1.id, 
	:age => 24, 
	:gender => 'Female', 
	:image => '/assets/the_bachelor/season19/nikki.jpg',
	:occupation => 'Executive Assistant', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Id quas sunt quam autem, itaque ducimus perferendis optio sint molestiae.')
cont3 = Contestant.create(
	:name => 'Jessica', 
	:season_id => season1.id, 
	:age => 32, 
	:gender => 'Female', 
	:image => '/assets/the_bachelor/season19/jessica.jpg',
	:occupation => 'Nurse', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique cum repudiandae quod officia expedita tenetur praesentium magnam.')
cont4 = Contestant.create(
	:name => 'Heather', 
	:season_id => season1.id, 
	:age => 26, 
	:gender => 'Female', 
	:image => '/assets/the_bachelor/season19/heather.jpg',
	:occupation => 'Hair Stylist', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!')
cont5 = Contestant.create(
	:name => 'Alex', 
	:season_id => season1.id, 
	:age => 24, 
	:gender => 'Female', 
	:image => '/assets/the_bachelor/season19/alex.jpg',
	:occupation => 'Entrepreneur', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!')
cont6 = Contestant.create(
	:name => 'Suzie', 
	:season_id => season1.id, 
	:age => 24, 
	:image => '/assets/the_bachelor/season19/suzie.jpg',
	:gender => 'Female', 
	:occupation => 'Web Designer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!')

episode1 = Episode.create(:season_id => season3.id, :air_date => '07/01/2013')
episode2 = Episode.create(:season_id => season3.id, :air_date => '14/01/2013')
episode3 = Episode.create(:season_id => season3.id, :air_date => '21/01/2013')
episode4 = Episode.create(:season_id => season3.id, :air_date => '28/01/2013')
episode5 = Episode.create(:season_id => season3.id, :air_date => '04/02/2013')
episode6 = Episode.create(:season_id => season3.id, :air_date => '05/02/2013')
episode7 = Episode.create(:season_id => season3.id, :air_date => '11/02/2013')
episode8 = Episode.create(:season_id => season3.id, :air_date => '18/02/2013')
episode9 = Episode.create(:season_id => season3.id, :air_date => '25/02/2013')
episode10 = Episode.create(:season_id => season3.id, :air_date => '11/03/2013')

ep1blrte = Episode.create(:season_id => season2.id, :air_date => '19/05/2014')
ep2blrte = Episode.create(:season_id => season2.id, :air_date => '26/05/2014') 
ep3blrte = Episode.create(:season_id => season2.id, :air_date => '01/06/2014')
ep4blrte = Episode.create(:season_id => season2.id, :air_date => '08/06/2014')
ep5blrte = Episode.create(:season_id => season2.id, :air_date => '16/06/2014')
ep6blrte = Episode.create(:season_id => season2.id, :air_date => '23/06/2014')
ep7blrte = Episode.create(:season_id => season2.id, :air_date => '30/06/2014')
ep8blrte = Episode.create(:season_id => season2.id, :air_date => '07/07/2014')
ep9blrte = Episode.create(:season_id => season2.id, :air_date => '14/07/2014')
ep10blrte = Episode.create(:season_id => season2.id, :air_date => '28/07/2014')

cont7 = Contestant.create(
	:name => 'Catherine', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/catherine.jpg', 
	:age => 26, 
	:gender => 'Female', 
	:occupation => 'Graphic Designer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Winner',
	:present => true,
	:episode_id => episode10.id)
cont8 = Contestant.create(
	:name => 'Lindsay', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/lindsay.jpg', 
	:age => 24, 
	:gender => 'Female', 
	:occupation => 'Substitute Teacher', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Runner-up',
	:present => false,
	:episode_id => episode10.id)
cont9 = Contestant.create(
	:name => 'AshLee', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/ashlee.jpg', 
	:age => 32, 
	:gender => 'Female', 
	:occupation => 'Personal Organizer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode9.id)
cont10 = Contestant.create(
	:name => 'Desiree', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/desiree.jpg', 
	:age => 26, 
	:gender => 'Female', 
	:occupation => 'Bridal Stylist', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode8.id)
cont11 = Contestant.create(
	:name => 'Lesley M.', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/lesley.jpg', 
	:age => 24, 
	:gender => 'Female', 
	:occupation => 'Political Consultant', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode7.id)
cont12 = Contestant.create(
	:name => 'Tierra', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/tierra.jpg', 
	:age => 24, 
	:gender => 'Female', 
	:occupation => 'Leasing Consultant', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode7.id)
cont13 = Contestant.create(
	:name => 'Daniella', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/daniella.jpg', 
	:age => 24, 
	:gender => 'Female', 
	:occupation => 'Commercial Casting Associate', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode6.id)
cont14 = Contestant.create(
	:name => 'Selma', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/selma.jpg', 
	:age => 29, 
	:gender => 'Female', 
	:occupation => 'Real Estate Dealer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode6.id)
cont15 = Contestant.create(
	:name => 'Sarah', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/sarah.jpg', 
	:age => 26, 
	:gender => 'Female', 
	:occupation => 'Advertising Executive', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode6.id)
cont16 = Contestant.create(
	:name => 'Robyn', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/robyn.jpg', 
	:age => 24, 
	:gender => 'Female', 
	:occupation => 'Oil Field Account Manager', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode5.id)
cont17 = Contestant.create(
	:name => 'Jackie', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/jackie.jpg', 
	:age => 25, 
	:gender => 'Female', 
	:occupation => 'Cosmetics Consultant', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode5.id)
cont18 = Contestant.create(
	:name => 'Amanda', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/amanda.jpg', 
	:age => 28, 
	:gender => 'Female', 
	:occupation => 'Fit Model', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode4.id)
cont19 = Contestant.create(
	:name => 'Leslie H.', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/leslie.jpg', 
	:age => 26, 
	:gender => 'Female', 
	:occupation => 'Poker Dealer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode4.id)
cont20 = Contestant.create(
	:name => 'Kristy', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/kristy.jpg', 
	:age => 26, 
	:gender => 'Female', 
	:occupation => 'Model', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode3.id)
cont21 = Contestant.create(
	:name => 'Taryn', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/taryn.jpg', 
	:age => 30, 
	:gender => 'Female', 
	:occupation => 'Health Club Manager', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode3.id)
cont22 = Contestant.create(
	:name => 'Kacie', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/kacie.jpg', 
	:age => 25, 
	:gender => 'Female', 
	:occupation => 'Community Organizer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode3.id)
cont23 = Contestant.create(
	:name => 'Brooke', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/brooke.jpg', 
	:age => 25, 
	:gender => 'Female', 
	:occupation => 'Graphic Designer', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode2.id)
cont24 = Contestant.create(
	:name => 'Diana', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/diana.jpg', 
	:age => 31, 
	:gender => 'Female', 
	:occupation => 'Salon Owner', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Eliminated',
	:present => false,
	:episode_id => episode2.id)
cont25 = Contestant.create(
	:name => 'Katie', 
	:season_id => season3.id, 
	:image => '/assets/the_bachelor/season18/katie.jpg', 
	:age => 27, 
	:gender => 'Female', 
	:occupation => 'Yoga Instructor', 
	:description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', 
	:status_on_show => 'Quit',
	:present => false,
	:episode_id => episode2.id)

voice7cont1 = Contestant.create(:name => 'Luke Wade', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/25/LukeWade_Null_1455x1455_KO_1_1.jpg?itok=-z0At4qS', :age => 31, :gender => 'N/A', :description => 'Hometown: Dublin, Texas',  :status_on_show => 'Present')
voice7cont2 = Contestant.create(:name => 'Clara Hong', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/ClaraHong_Null_1455x1455_RUBEN.jpg?itok=Zs7E4UXw', :age => 22, :gender => 'N/A', :description => 'Hometown: Atlanta, Georgia',  :status_on_show => 'Present')
voice7cont3 = Contestant.create(:name => 'Bryana Salaz', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/22/BryanaSalaz_Null_1455x1455_KO.jpg?itok=Ny-8WJNE', :age => 16, :gender => 'N/A', :description => 'Hometown: San Antonio, Texas',  :status_on_show => 'Present')
voice7cont4 = Contestant.create(:name => 'Damien Lawson', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/22/DamienLawson_Null_1455x1455_KO.jpg?itok=IhHFhx1Z', :age => 35, :gender => 'N/A', :description => 'Hometown: Monroe, Louisiana',  :status_on_show => 'Present')
voice7cont5 = Contestant.create(:name => 'Allison Bray', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/AllisonBray_Null_1455x1455_RUBEN.jpg?itok=9_riJD5g', :age => 18, :gender => 'N/A', :description => 'Hometown: Louisville, Kentucky',  :status_on_show => 'Present')
voice7cont6 = Contestant.create(:name => 'Taylor John Williams', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/TaylorJohnWilliams_Null_1455x1455_RUBEN.jpg?itok=y0mGySIc', :age => 23, :gender => 'N/A', :description => 'Hometown: Portland, Oregon',  :status_on_show => 'Present')
voice7cont7 = Contestant.create(:name => 'Elyjuh René', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/22/ElyjuhRene_Null_1455x1455_KO.jpg?itok=EEsVV9ZL', :age => 18, :gender => 'N/A', :description => 'Hometown: Long Beach, California',  :status_on_show => 'Present')
voice7cont8 = Contestant.create(:name => 'James David Carter', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/JamesDavidCarter_Null_1455x1455_RUBEN.jpg?itok=JgpbQexh', :age => 34, :gender => 'N/A', :description => 'Hometown: Jacksonville, Florida',  :status_on_show => 'Present')
voice7cont9 = Contestant.create(:name => 'DaNica Shirey', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/DanicaShirey_Null_1455x1455_KO.jpg?itok=pmyqWD-m', :age => 25, :gender => 'N/A', :description => 'Hometown: York, Pennsylvania',  :status_on_show => 'Present')
voice7cont10 = Contestant.create(:name => 'Joe Kirk', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/JoeKirk_Null_1455x1455_KO.jpg?itok=9PkbLbTL', :age => 17, :gender => 'N/A', :description => 'Hometown: Nashville, Tennessee',  :status_on_show => 'Present')
voice7cont11 = Contestant.create(:name => 'Menlik Zergabachew', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/MenlikZergabachew_Null_1455x1455_KO.jpg?itok=RIukha9D', :age => 19, :gender => 'N/A', :description => 'Hometown: Silver Spring, Maryland',  :status_on_show => 'Present')
voice7cont12 = Contestant.create(:name => 'Reagan James', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/ReaganJames_Null_1455x1455_KO.jpg?itok=Xtbm-QG0', :age => 15, :gender => 'N/A', :description => 'Hometown: Burleson, Texas',  :status_on_show => 'Present')
voice7cont13 = Contestant.create(:name => 'Taylor Phelan', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/TaylorPhelan_Null_1455x1455_KO.jpg?itok=gXJL6-Sg', :age => 25, :gender => 'N/A', :description => 'Hometown: Sherman, Texas',  :status_on_show => 'Present')
voice7cont14 = Contestant.create(:name => 'Sugar Joans', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/SugarJoans_Null_1455x1455_KO.jpg?itok=Nhn9EaZS', :age => 24, :gender => 'N/A', :description => 'Hometown: Los Angeles, California',  :status_on_show => 'Present')
voice7cont15 = Contestant.create(:name => 'Taylor Brashears', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/TaylorBrashears_Null_1455x1455_KO.jpg?itok=l9oNQX9I', :age => 21, :gender => 'N/A', :description => 'Hometown: Nashville, Tennessee',  :status_on_show => 'Present')
voice7cont16 = Contestant.create(:name => 'Maiya Sykes', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/23/MaiyaSykes_Null_1455x1455_KO.jpg?itok=B1d-tCxY', :age => 36, :gender => 'N/A', :description => 'Hometown: Los Angeles, California',  :status_on_show => 'Present')
voice7cont17 = Contestant.create(:name => 'John Martin', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/JohnMartin_Null_1455x1455_KO.jpg?itok=gWGZ0Bt4', :age => 25, :gender => 'N/A', :description => 'Hometown: Saint Louis, Missouri',  :status_on_show => 'Present')
voice7cont18 = Contestant.create(:name => 'Jessie Pitts', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/JessiePitts_Null_1455x1455_KO.jpg?itok=Ol51hoxI', :age => 18, :gender => 'N/A', :description => 'Hometown: Montgomery, Alabama',  :status_on_show => 'Present')
voice7cont19 = Contestant.create(:name => 'Ricky Manning', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/RickyManning_Null_1455x1455_KO.jpg?itok=jx6ntDtc', :age => 19, :gender => 'N/A', :description => 'Hometown: Cape Coral, Florida',  :status_on_show => 'Present')
voice7cont20 = Contestant.create(:name => 'Kelli Douglas', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/KelliDouglas_Null_1455x1455_KO.jpg?itok=4onfBlax', :age => 31, :gender => 'N/A', :description => 'Hometown: Dallas, Texas',  :status_on_show => 'Present')
voice7cont21 = Contestant.create(:name => 'Blessing Offor', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/BlessingOffor_Null_1455x1455_KO.jpg?itok=1oHziOfj', :age => 25, :gender => 'N/A', :description => 'Hometown: New York, New York',  :status_on_show => 'Present')
voice7cont22 = Contestant.create(:name => 'Troy Ritchie', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/TroyRichie_Null_1455x1455_KO.jpg?itok=d9KsNQRP', :age => 21, :gender => 'N/A', :description => 'Hometown: Trabuco Canyon, California',  :status_on_show => 'Present')
voice7cont23 = Contestant.create(:name => 'Mia Pfirrman', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/MiaPfirrman_Null_1455x1455_KO.jpg?itok=H7ypv2Lc', :age => 19, :gender => 'N/A', :description => 'Hometown: Temple City, California',  :status_on_show => 'Present')
voice7cont24 = Contestant.create(:name => 'Alessandra Castronovo', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/AlessandraCastronovo_Null_1455x1455_KO.jpg?itok=-RZtBrpn', :age => 21, :gender => 'N/A', :description => 'Hometown: Millstone, New Jersey',  :status_on_show => 'Present')
voice7cont25 = Contestant.create(:name => 'Jordy Searcy', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/JordySearcy_Null_1455x1455_KO.jpg?itok=NOZAO_Jv', :age => 20, :gender => 'N/A', :description => 'Hometown: Fairhope, Alabama',  :status_on_show => 'Present')
voice7cont26 = Contestant.create(:name => 'Kensington Moore', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/KensingtonMoore_Null_1455x1455_KO.jpg?itok=1_KKtDWk', :age => 18, :gender => 'N/A', :description => 'Hometown: Georgetown, Kentucky',  :status_on_show => 'Present')
voice7cont27 = Contestant.create(:name => 'Bree Fondacaro', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/BreeFondacaro_Null_1455x1455_KO.jpg?itok=2koAD45f', :age => 24, :gender => 'N/A', :description => 'Hometown: Orange County, California',  :status_on_show => 'Present')
voice7cont28 = Contestant.create(:name => 'Anita Antoinette', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/29/AnitaAntoinette_Null_1455x1455_KO.jpg?itok=-BX4lPMc', :age => 24, :gender => 'N/A', :description => 'Hometown: Boston, Massachusetts',  :status_on_show => 'Present')
voice7cont29 = Contestant.create(:name => 'Katriz Trinidad', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/KatrizTrinidad_Null_1455x1455_KO.jpg?itok=svt0TZ9L', :age => 15, :gender => 'N/A', :description => 'Hometown: San Diego, California',  :status_on_show => 'Present')
voice7cont30 = Contestant.create(:name => 'Ethan Butler', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/EthanButler_Null_1455x1455_KO.jpg?itok=foReHGiQ', :age => 25, :gender => 'N/A', :description => 'Hometown: Chicago, Illinois',  :status_on_show => 'Present')
voice7cont31 = Contestant.create(:name => 'Tanner Linford', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/TannerLinford_Null_1455x1455_KO.jpg?itok=xA2xk--V', :age => 17, :gender => 'N/A', :description => 'Hometown: Kaysville, Utah',  :status_on_show => 'Present')
voice7cont32 = Contestant.create(:name => 'Jean Kelley', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/JeanKelley_Null_1455x1455_KO.jpg?itok=B4if2hmG', :age => 29, :gender => 'N/A', :description => 'Hometown: Nashville, Tennessee',  :status_on_show => 'Present')
voice7cont33 = Contestant.create(:name => 'Chris Jamison', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/ChrisJamison_Null_1455x1455_KO.jpg?itok=2irGUJ_0', :age => 21, :gender => 'N/A', :description => 'Hometown: Pittsburgh, Pennsylvania',  :status_on_show => 'Present')
voice7cont34 = Contestant.create(:name => 'Craig Wayne Boyd', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/CraigWayneBoyd_Null_1455x1455_KO.jpg?itok=Zd-RUHKn', :age => 35, :gender => 'N/A', :description => 'Hometown: Nashville, Tennessee',  :status_on_show => 'Present')
voice7cont35 = Contestant.create(:name => 'Toia Jones', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/ToiaJones_Null_1455x1455_KO.jpg?itok=Wg0fOheD', :age => 29, :gender => 'N/A', :description => 'Hometown: Montgomery, Alabama',  :status_on_show => 'Present')
voice7cont36 = Contestant.create(:name => 'Amanda Lee Peers', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/AmandaLeePeers_Null_1455x1455_KO.jpg?itok=oP7j38qD', :age => 29, :gender => 'N/A', :description => 'Hometown: Rochester, New York',  :status_on_show => 'Present')
voice7cont37 = Contestant.create(:name => 'Gianna Salvato', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/GiannaSalvato_Null_1455x1455_KO.jpg?itok=n1g-oPDc', :age => 18, :gender => 'N/A', :description => 'Hometown: Freehold, New Jersey',  :status_on_show => 'Present')
voice7cont38 = Contestant.create(:name => 'Rebekah Samarin', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/RebekahSamarin_Null_1455x1455_KO.jpg?itok=0U6uzY9d', :age => 31, :gender => 'N/A', :description => 'Hometown: Whittier, California',  :status_on_show => 'Present')
voice7cont39 = Contestant.create(:name => 'Grant Ganzer', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/GrantGanzer_Null_1455x1455_KO.jpg?itok=RA2ME7XA', :age => 16, :gender => 'N/A', :description => 'Hometown: Johnston, Iowa',  :status_on_show => 'Present')
voice7cont40 = Contestant.create(:name => 'Jonathan Wyndham', :season_id => season4.id, :image => 'http://www.nbc.com/sites/nbcunbc/files/files/styles/nbc_contestants_teams_thumb/public/images/2014/9/30/JonathanWyndham_Null_1455x1455_KO.jpg?itok=KPOsDqA9', :age => 22, :gender => 'N/A', :description => 'Hometown: Lexington, South Carolina',  :status_on_show => 'Present')
voice7cont41 = Contestant.create(:name => 'Matt McAndrew', :season_id => season4.id, :image => '#', :age => 23, :gender => 'N/A', :description => 'Hometown: Philadelphia, Pennsylvania',  :status_on_show => 'Present')

roster1 = Roster.create(:user_id => user1.id, :league_id => league3.id)
roster2 = Roster.create(:user_id => user4.id, :league_id => league3.id)
roster3 = Roster.create(:user_id => user5.id, :league_id => league3.id)
roster4 = Roster.create(:user_id => user1.id, :league_id => league2.id)
roster5 = Roster.create(:user_id => user3.id, :league_id => league2.id)
roster6 = Roster.create(:user_id => user4.id, :league_id => league2.id)
roster7 = Roster.create(:user_id => user5.id, :league_id => league2.id)
roster8 = Roster.create(:user_id => user1.id, :league_id => league1.id)
roster9 = Roster.create(:user_id => user2.id, :league_id => league1.id)
roster10 = Roster.create(:user_id => user3.id, :league_id => league1.id)

roster10 = Roster.create(:user_id => user1.id, :league_id => league4.id)
roster11 = Roster.create(:user_id => user2.id, :league_id => league4.id)
roster10.contestants << [cont7, cont8, cont9, cont10, cont11, cont12, cont13, cont14, cont15, cont16, cont17, cont18, cont19, cont20, cont21, cont22, cont23, cont24, cont25]
roster11.contestants << [cont7, cont8, cont9, cont10, cont11, cont12, cont13, cont14, cont15, cont16, cont17, cont18, cont19, cont20, cont21, cont22, cont23, cont24, cont25]

# Roster for Edelman's Bachelor League (The Bachelor)
roster1.contestants << [cont1, cont2, cont3, cont4]
roster2.contestants << [cont2, cont3, cont4, cont5]
roster3.contestants << [cont3, cont4, cont5, cont6]

round1 = Round.create(:roster_id => roster10.id, :episode_id => episode1.id)
round1.contestants << roster10.contestants.clone
round2 = Round.create(:roster_id => roster10.id, :episode_id => episode2.id)
round2.contestants << round1.contestants.clone
round2.contestants.delete(cont23, cont24, cont25)
round3 = Round.create(:roster_id => roster10.id, :episode_id => episode3.id)
round3.contestants << round2.contestants.clone
round3.contestants.delete(cont20, cont21, cont22)
round4 = Round.create(:roster_id => roster10.id, :episode_id => episode4.id)
round4.contestants << round3.contestants.clone
round4.contestants.delete(cont18, cont19)
round5 = Round.create(:roster_id => roster10.id, :episode_id => episode5.id)
round5.contestants << round4.contestants.clone
round5.contestants.delete(cont16, cont17)
round6 = Round.create(:roster_id => roster10.id, :episode_id => episode6.id)
round6.contestants << round5.contestants.clone
round6.contestants.delete(cont13, cont15)
round7 = Round.create(:roster_id => roster10.id, :episode_id => episode7.id)
round7.contestants << round6.contestants.clone
round7.contestants.delete(cont10, cont14)
round8 = Round.create(:roster_id => roster10.id, :episode_id => episode8.id)
round8.contestants << round7.contestants.clone
round8.contestants.delete(cont9, cont11)
round9 = Round.create(:roster_id => roster10.id, :episode_id => episode9.id)
round9.contestants << round8.contestants.clone
round9.contestants.delete(cont8)
round10 = Round.create(:roster_id => roster10.id, :episode_id => episode10.id)
round10.contestants << round9.contestants.clone
round10.contestants.delete(cont12)

round11 = Round.create(:roster_id => roster11.id, :episode_id => episode1.id)
round11.contestants << roster11.contestants.clone
round12 = Round.create(:roster_id => roster11.id, :episode_id => episode2.id)
round12.contestants << round11.contestants.clone
round12.contestants.delete(cont13, cont16, cont23)
round13 = Round.create(:roster_id => roster11.id, :episode_id => episode3.id)
round13.contestants << round12.contestants.clone
round13.contestants.delete(cont19, cont20, cont21)
round14 = Round.create(:roster_id => roster11.id, :episode_id => episode4.id)
round14.contestants << round13.contestants.clone
round14.contestants.delete(cont8, cont17)
round15 = Round.create(:roster_id => roster11.id, :episode_id => episode5.id)
round15.contestants << round14.contestants.clone
round15.contestants.delete(cont7, cont10)
round16 = Round.create(:roster_id => roster11.id, :episode_id => episode6.id)
round16.contestants << round15.contestants.clone
round16.contestants.delete(cont25, cont24)
round17 = Round.create(:roster_id => roster11.id, :episode_id => episode7.id)
round17.contestants << round16.contestants.clone
round17.contestants.delete(cont22, cont18)
round18 = Round.create(:roster_id => roster11.id, :episode_id => episode8.id)
round18.contestants << round17.contestants.clone
round18.contestants.delete(cont12, cont14)
round19 = Round.create(:roster_id => roster11.id, :episode_id => episode9.id)
round19.contestants << round18.contestants.clone
round19.contestants.delete(cont15)
round20 = Round.create(:roster_id => roster11.id, :episode_id => episode10.id)
round20.contestants << round19.contestants.clone
round20.contestants.delete(cont11)

survival1 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 1', :points_asgn => 10)
survival2 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 2', :points_asgn => 20)
survival3 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 3', :points_asgn => 30)
survival4 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 4', :points_asgn => 40)
survival5 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 5', :points_asgn => 50)
survival6 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 6', :points_asgn => 60)
survival7 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 7', :points_asgn => 70)
survival8 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 8', :points_asgn => 80)
survival9 = Survival.create(:show_id => show1.id, :description => 'Contestant receives a rose in Week 9', :points_asgn => 90)
survival10 = Survival.create(:show_id => show1.id, :description => 'Contestant receives the Final Rose', :points_asgn => 100)
survival11 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 1', :points_asgn => 10)
survival12 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 2', :points_asgn => 10)
survival13 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 3', :points_asgn => 10)
survival14 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 4', :points_asgn => 10)
survival15 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 5', :points_asgn => 10)
survival16 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 6', :points_asgn => 10)
survival17 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 7', :points_asgn => 10)
survival18 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 8', :points_asgn => 10)
survival19 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in Week 9', :points_asgn => 10)
survival20 = Survival.create(:show_id => show1.id, :description => 'Contestant leaves on her own accord in the Finale', :points_asgn => 10)
survival21 = Survival.create(:show_id => show1.id, :description => 'Contestant is asked to leave by the producer', :points_asgn => 100)
game22 = Game.create(:show_id => show1.id, :description => 'Contestant is chosen for 1-on-1 date', :points_asgn => 50)
game23 = Game.create(:show_id => show1.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
game24 = Game.create(:show_id => show1.id, :description => 'Contestant gets in a helicopter', :points_asgn => 25)
game25 = Game.create(:show_id => show1.id, :description => 'Contestant gets a Fantasy Suite invitation', :points_asgn => 75)
game26 = Game.create(:show_id => show1.id, :description => 'Contestant rejects a Fantay Suite invitation', :points_asgn => 100)
game27 = Game.create(:show_id => show1.id, :description => 'Contestant meets the bachelor\'s family', :points_asgn => 50)
game28 = Game.create(:show_id => show1.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
game29 = Game.create(:show_id => show1.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
extra30 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant kisses the bachelor', :points_asgn => 10)
extra31 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant gets in the hot tub with the bachelor', :points_asgn => 20)
extra32 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant cries', :points_asgn => 10)
extra33 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant gets in a fight with another contestant', :points_asgn => 25)
extra34 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant says she\'s "here for the right reason" ', :points_asgn => 15)
extra35 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant gets inappropriately drunk', :points_asgn => 25)
extra36 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant gets injured', :points_asgn => 25)
extra37 = Extracurricular.create(:show_id => show1.id, :description => 'Contestant gives the bachelor a gift', :points_asgn => 10)
survival38 = Survival.create(:show_id => show1.id, :description => 'Contestant gets eliminated', :points_asgn => 0)

survival40 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 1', :points_asgn => 10)
survival41 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 2', :points_asgn => 20)
survival42 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 3', :points_asgn => 30)
survival43 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 4', :points_asgn => 40)
survival44 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 5', :points_asgn => 50)
survival45 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 6', :points_asgn => 60)
survival46 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 7', :points_asgn => 70)
survival47 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 8', :points_asgn => 80)
survival48 = Survival.create(:show_id => show2.id, :description => 'Contestant receives a rose in Week 9', :points_asgn => 90)
survival49 = Survival.create(:show_id => show2.id, :description => 'Contestant receives the Final Rose', :points_asgn => 100)
survival50 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 1', :points_asgn => 10)
survival51 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 2', :points_asgn => 10)
survival52 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 3', :points_asgn => 10)
survival53 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 4', :points_asgn => 10)
survival54 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 5', :points_asgn => 10)
survival55 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 6', :points_asgn => 10)
survival56 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 7', :points_asgn => 10)
survival57 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 8', :points_asgn => 10)
survival58 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in Week 9', :points_asgn => 10)
survival59 = Survival.create(:show_id => show2.id, :description => 'Contestant leaves on his own accord in the Finale', :points_asgn => 10)
survival60 = Survival.create(:show_id => show2.id, :description => 'Contestant is asked to leave by the producer', :points_asgn => 100)
survival61 = Survival.create(:show_id => show2.id, :description => 'Contestant gets eliminated', :points_asgn => 0)
game62 = Game.create(:show_id => show2.id, :description => 'Contestant is chosen for 1-on-1 date', :points_asgn => 50)
game63 = Game.create(:show_id => show2.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
game64 = Game.create(:show_id => show2.id, :description => 'Contestant gets in a helicopter', :points_asgn => 25)
game65 = Game.create(:show_id => show2.id, :description => 'Contestant gets a Fantasy Suite invitation', :points_asgn => 75)
game66 = Game.create(:show_id => show2.id, :description => 'Contestant rejects a Fantay Suite invitation', :points_asgn => 100)
game67 = Game.create(:show_id => show2.id, :description => 'Contestant meets the bachelorette\'s family', :points_asgn => 50)
game68 = Game.create(:show_id => show2.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
game69 = Game.create(:show_id => show2.id, :description => 'Contestant is chosen for group date', :points_asgn => 25)
extra70 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant kisses the bachelorette', :points_asgn => 10)
extra71 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant gets in the hot tub with the bachelorette', :points_asgn => 20)
extra72 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant cries', :points_asgn => 10)
extra73 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant gets in a fight with another contestant', :points_asgn => 25)
extra74 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant says he\'s "here for the right reason" ', :points_asgn => 15)
extra75 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant gets inappropriately drunk', :points_asgn => 25)
extra76 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant gets injured', :points_asgn => 25)
extra77 = Extracurricular.create(:show_id => show2.id, :description => 'Contestant gives the bachelorette a gift', :points_asgn => 10)

survival78 = Survival.create(:show_id => show3.id, :description => 'Contestant gets selected during the Blind Audition', :points_asgn => 10)
survival79 = Survival.create(:show_id => show3.id, :description => 'Contestant gets stolen by another coach during the Battle', :points_asgn => 20)

event1 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event2 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event3 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event4 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event5 = Event.create!(:contestant_id => cont16.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event6 = Event.create!(:contestant_id => cont25.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event7 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event8 = Event.create!(:contestant_id => cont17.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event9 = Event.create!(:contestant_id => cont19.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event10 = Event.create!(:contestant_id => cont24.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event11 = Event.create!(:contestant_id => cont23.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event12 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event13 = Event.create!(:contestant_id => cont18.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event14 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event15 = Event.create!(:contestant_id => cont22.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event16 = Event.create!(:contestant_id => cont20.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event17 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event18 = Event.create!(:contestant_id => cont21.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event19 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival1.id, :episode_id => episode1.id)
event20 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event21 = Event.create!(:contestant_id => cont22.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event22 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event23 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event24 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event25 = Event.create!(:contestant_id => cont16.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event26 = Event.create!(:contestant_id => cont17.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event27 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event28 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event29 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event30 = Event.create!(:contestant_id => cont20.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event31 = Event.create!(:contestant_id => cont19.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event32 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event33 = Event.create!(:contestant_id => cont21.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event34 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event35 = Event.create!(:contestant_id => cont18.id, :scheme_id => survival2.id, :episode_id => episode2.id)
event36 = Event.create!(:contestant_id => cont23.id, :scheme_id => survival38.id, :episode_id => episode2.id)
event37 = Event.create!(:contestant_id => cont24.id, :scheme_id => survival38.id, :episode_id => episode2.id)
event38 = Event.create!(:contestant_id => cont25.id, :scheme_id => survival12.id, :episode_id => episode2.id)
event39 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont19.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont16.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event40 = Event.create!(:contestant_id => cont17.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event50 = Event.create!(:contestant_id => cont18.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event51 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event51 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival3.id, :episode_id => episode3.id)
event52 = Event.create!(:contestant_id => cont20.id, :scheme_id => survival38.id, :episode_id => episode3.id)
event53 = Event.create!(:contestant_id => cont21.id, :scheme_id => survival38.id, :episode_id => episode3.id)
event54 = Event.create!(:contestant_id => cont22.id, :scheme_id => survival38.id, :episode_id => episode3.id)
event55 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event56 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event57 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event58 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event59 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event60 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event61 = Event.create!(:contestant_id => cont16.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event62 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event63 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event64 = Event.create!(:contestant_id => cont17.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event65 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival4.id, :episode_id => episode4.id)
event66 = Event.create!(:contestant_id => cont18.id, :scheme_id => survival38.id, :episode_id => episode4.id)
event67 = Event.create!(:contestant_id => cont19.id, :scheme_id => survival38.id, :episode_id => episode4.id)
event68 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event69 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event70 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event71 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event72 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event73 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event74 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event75 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event76 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival5.id, :episode_id => episode5.id)
event77 = Event.create!(:contestant_id => cont16.id, :scheme_id => survival38.id, :episode_id => episode5.id)
event78 = Event.create!(:contestant_id => cont17.id, :scheme_id => survival38.id, :episode_id => episode5.id)
event79 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event80 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event81 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event82 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event83 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event84 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival6.id, :episode_id => episode6.id)
event85 = Event.create!(:contestant_id => cont13.id, :scheme_id => survival38.id, :episode_id => episode6.id)
event86 = Event.create!(:contestant_id => cont14.id, :scheme_id => survival38.id, :episode_id => episode6.id)
event87 = Event.create!(:contestant_id => cont15.id, :scheme_id => survival38.id, :episode_id => episode6.id)
event88 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival7.id, :episode_id => episode7.id)
event89 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival7.id, :episode_id => episode7.id)
event90 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival7.id, :episode_id => episode7.id)
event91 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival7.id, :episode_id => episode7.id)
event92 = Event.create!(:contestant_id => cont11.id, :scheme_id => survival7.id, :episode_id => episode7.id)
event93 = Event.create!(:contestant_id => cont12.id, :scheme_id => survival38.id, :episode_id => episode7.id)
event94 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival8.id, :episode_id => episode8.id)
event95 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival8.id, :episode_id => episode8.id)
event96 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival8.id, :episode_id => episode8.id)
event97 = Event.create!(:contestant_id => cont10.id, :scheme_id => survival38.id, :episode_id => episode8.id)
event98 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival9.id, :episode_id => episode9.id)
event99 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival9.id, :episode_id => episode9.id)
event100 = Event.create!(:contestant_id => cont9.id, :scheme_id => survival38.id, :episode_id => episode9.id)
event101 = Event.create!(:contestant_id => cont7.id, :scheme_id => survival10.id, :episode_id => episode10.id)
event102 = Event.create!(:contestant_id => cont8.id, :scheme_id => survival38.id, :episode_id => episode10.id)