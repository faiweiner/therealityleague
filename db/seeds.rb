# USERS
Bracket.destroy_all
Contestant.destroy_all
Episode.destroy_all
Event.destroy_all
Extracurricular.destroy_all
Fantasy.destroy_all
League.destroy_all
Point.destroy_all
Roster.destroy_all
Round.destroy_all
Season.destroy_all
Show.destroy_all
Survival.destroy_all
User.destroy_all

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

show1 = Show.create(:name => 'The Bachelor', :image => '/assets/the_bachelor/logo.jpg')
show2 = Show.create(:name => 'The Bachelorette', :image => '/assets/the_bachelorette/logo.png')
show3 = Show.create(:name => 'The Voice', :image => '/assets/the_voice/thevoice.jpg')
show4 = Show.create(:name => 'Bachelor in Paradise', :image => '/assets/bachelor_paradise/bachelor_paradise.jpg')
show5 = Show.create(:name => 'Master Chef', :image => '/assets/master_chef/masterchef.jpg')
show6 = Show.create(:name => 'The Challenge', :image => '/assets/the_challenge/thechallenge.jpg')

season1 = Season.create(:name => 'Juan Pablo', :number => 18, :show_id => show1.id, :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.', :episode_count => 10, :image => '/assets/the_bachelor/juanpablo.jpg')
season2 = Season.create(:name => 'Desiree', :number => 9, :show_id => show2.id, :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'This season features 27-year-old Desiree Hartsock, a bridal stylist from Colorado. Twenty-five men, all aged 26-34, will be competing for Desiree\'s heart.', :episode_count => 10, :image => '/assets/the_bachelorette/desiree.jpg')
season3 = Season.create(:name => 'Sean Lowe', :number => 17, :show_id => show1.id, :premiere_date => '01/07/2013', :finale_date => '01/12/2013', :description	=> 'The best bachelor ever - Sean Lowe is the man!', :image => '/assets/the_bachelor/logo.jpg', :episode_count => 10, :expired => true, :image => '/assets/the_bachelor/seanlowe.jpg')

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :season_id => season2.id, :draft_type => 'Fantasy', :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :season_id => season2.id, :draft_type => 'Fantasy', :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season1.id, :draft_type => 'Fantasy', :public_access => false)
league4 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season3.id, :draft_type => 'Bracket', :public_access => false, :active => false)

league1.users << [user1, user2, user3]
league2.users << [user1, user3, user4, user5]
league3.users << [user1, user4, user5]
league4.users << [user1, user2]

cont1 = Contestant.create(:name => 'Layla', :season_id => season1.id, :age => 22, :gender => 'Female', :occupation => 'Physical Therapist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis ullam doloribus, laborum asperiores aperiam.', :image => '/assets/the_bachelor/layla.jpg')
cont2 = Contestant.create(:name => 'Nikki', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Executive Assistant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Id quas sunt quam autem, itaque ducimus perferendis optio sint molestiae.', :image => '/assets/the_bachelor/nikki.jpg')
cont3 = Contestant.create(:name => 'Jessica', :season_id => season1.id, :age => 32, :gender => 'Female', :occupation => 'Nurse', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique cum repudiandae quod officia expedita tenetur praesentium magnam.', :image => '/assets/the_bachelor/jessica.jpg')
cont4 = Contestant.create(:name => 'Heather', :season_id => season1.id, :age => 26, :gender => 'Female', :occupation => 'Hair Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/heather.jpg')
cont5 = Contestant.create(:name => 'Alex', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Entrepreneur', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/alex.jpg')
cont6 = Contestant.create(:name => 'Suzie', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Web Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/suzie.jpg')

cont7 = Contestant.create(:name => 'Catherine', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/catherine.jpg')
cont8 = Contestant.create(:name => 'Lindsay', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Substitute Teacher', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/lindsay.jpg')
cont9 = Contestant.create(:name => 'AshLee', :season_id => season3.id, :age => 32, :gender => 'Female', :occupation => 'Personal Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/ashlee.jpg')
cont10 = Contestant.create(:name => 'Desiree', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Bridal Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/desiree.jpg')
cont11 = Contestant.create(:name => 'Lesley M.', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Political Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/lesley.jpg')
cont12 = Contestant.create(:name => 'Tierra', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Leasing Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/tierra.jpg')
cont13 = Contestant.create(:name => 'Daniella', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Commercial Casting Associate', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/daniella.jpg')
cont14 = Contestant.create(:name => 'Selma', :season_id => season3.id, :age => 29, :gender => 'Female', :occupation => 'Real Estate Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/selma.jpg')
cont15 = Contestant.create(:name => 'Sarah', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Advertising Executive', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/sarah.jpg')
cont16 = Contestant.create(:name => 'Robyn', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Oil Field Account Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/robyn.jpg')
cont17 = Contestant.create(:name => 'Jackie', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Cosmetics Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/jackie.jpg')
cont18 = Contestant.create(:name => 'Amanda', :season_id => season3.id, :age => 28, :gender => 'Female', :occupation => 'Fit Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/amanda.jpg')
cont19 = Contestant.create(:name => 'Leslie H.', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Poker Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/leslie.jpg')
cont20 = Contestant.create(:name => 'Kristy', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/kristy.jpg')
cont21 = Contestant.create(:name => 'Taryn', :season_id => season3.id, :age => 30, :gender => 'Female', :occupation => 'Health Club Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/taryn.jpg')
cont22 = Contestant.create(:name => 'Kacie', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Community Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/kacie.jpg')
cont23 = Contestant.create(:name => 'Brooke', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/brooke.jpg')
cont24 = Contestant.create(:name => 'Diana', :season_id => season3.id, :age => 31, :gender => 'Female', :occupation => 'Salon Owner', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/diana.jpg')
cont25 = Contestant.create(:name => 'Katie', :season_id => season3.id, :age => 27, :gender => 'Female', :occupation => 'Yoga Instructor', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/the_bachelor/season18/katie.jpg')

roster1 = Bracket.create(:user_id => user1.id, :league_id => league3.id)
roster2 = Bracket.create(:user_id => user4.id, :league_id => league3.id)
roster3 = Bracket.create(:user_id => user5.id, :league_id => league3.id)
roster4 = Bracket.create(:user_id => user1.id, :league_id => league2.id)
roster5 = Fantasy.create(:user_id => user3.id, :league_id => league2.id)
roster6 = Fantasy.create(:user_id => user4.id, :league_id => league2.id)
roster7 = Fantasy.create(:user_id => user5.id, :league_id => league2.id)
roster8 = Fantasy.create(:user_id => user1.id, :league_id => league1.id)
roster9 = Fantasy.create(:user_id => user2.id, :league_id => league1.id)
roster10 = Fantasy.create(:user_id => user3.id, :league_id => league1.id)

roster10 = Bracket.create(:user_id => user1.id, :league_id => league4.id)
roster11 = Bracket.create(:user_id => user2.id, :league_id => league4.id)
roster10.contestants << [cont7, cont8, cont9, cont10, cont11, cont12, cont13, cont14, cont15, cont16, cont17, cont18, cont19, cont20, cont21, cont22, cont23, cont24, cont25]
roster11.contestants << [cont7, cont8, cont9, cont10, cont11, cont12, cont13, cont14, cont15, cont16, cont17, cont18, cont19, cont20, cont21, cont22, cont23, cont24, cont25]

# Roster for Edelman's Bachelor League (The Bachelor)
roster1.contestants << [cont1, cont2, cont3, cont4]
roster2.contestants << [cont2, cont3, cont4, cont5]
roster3.contestants << [cont3, cont4, cont5, cont6]

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

survival1 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 1', :points_asgn => 10)
survival2 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 2', :points_asgn => 20)
survival3 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 3', :points_asgn => 30)
survival4 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 4', :points_asgn => 40)
survival5 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 5', :points_asgn => 50)
survival6 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 6', :points_asgn => 60)
survival7 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 7', :points_asgn => 70)
survival8 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 8', :points_asgn => 80)
survival9 = Survival.create(:show_id => show1.id, :event => 'Contestant receives a rose in Week 9', :points_asgn => 90)
survival10 = Survival.create(:show_id => show1.id, :event => 'Contestant receives the Final Rose', :points_asgn => 100)
survival11 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 1', :points_asgn => 10)
survival12 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 2', :points_asgn => 10)
survival13 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 3', :points_asgn => 10)
survival14 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 4', :points_asgn => 10)
survival15 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 5', :points_asgn => 10)
survival16 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 6', :points_asgn => 10)
survival17 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 7', :points_asgn => 10)
survival18 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 8', :points_asgn => 10)
survival19 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in Week 9', :points_asgn => 10)
survival20 = Survival.create(:show_id => show1.id, :event => 'Contestant leaves on her own accord in the Finale', :points_asgn => 10)
survival21 = Survival.create(:show_id => show1.id, :event => 'Contestant is asked to leave by the producer', :points_asgn => 100)
survival38 = Survival.create(:show_id => show1.id, :event => 'Contestant gets eliminated', :points_asgn => 0)

game22 = Game.create(:show_id => show1.id, :event => 'Contestant is chosen for 1-on-1 date', :points_asgn => 50)
game23 = Game.create(:show_id => show1.id, :event => 'Contestant is chosen for group date', :points_asgn => 25)
game24 = Game.create(:show_id => show1.id, :event => 'Contestant gets in a helicopter', :points_asgn => 25)
game25 = Game.create(:show_id => show1.id, :event => 'Contestant gets a Fantasy Suite invitation', :points_asgn => 75)
game26 = Game.create(:show_id => show1.id, :event => 'Contestant rejects a Fantay Suite invitation', :points_asgn => 100)
game27 = Game.create(:show_id => show1.id, :event => 'Contestant meets the bachelor\'s family', :points_asgn => 50)
game28 = Game.create(:show_id => show1.id, :event => 'Contestant is chosen for group date', :points_asgn => 25)
game29 = Game.create(:show_id => show1.id, :event => 'Contestant is chosen for group date', :points_asgn => 25)

extra30 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant kisses the bachelor', :points_asgn => 10)
extra31 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant gets in the hot tub with the bachelor', :points_asgn => 20)
extra32 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant cries', :points_asgn => 10)
extra33 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant gets in a fight with another contestant', :points_asgn => 25)
extra34 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant says she\'s "here for the right reason" ', :points_asgn => 15)
extra35 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant gets inappropriately drunk', :points_asgn => 25)
extra36 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant gets injured', :points_asgn => 25)
extra37 = Extracurricular.create(:show_id => show1.id, :event => 'Contestant gives the bachelor a gift', :points_asgn => 10)

point1 = Point.create!(:contestant_id => cont12.id, :event_id => survival1.id, :episode_id => episode1.id)
point2 = Point.create!(:contestant_id => cont10.id, :event_id => survival1.id, :episode_id => episode1.id)
point3 = Point.create!(:contestant_id => cont9.id, :event_id => survival1.id, :episode_id => episode1.id)
point4 = Point.create!(:contestant_id => cont14.id, :event_id => survival1.id, :episode_id => episode1.id)
point5 = Point.create!(:contestant_id => cont16.id, :event_id => survival1.id, :episode_id => episode1.id)
point6 = Point.create!(:contestant_id => cont25.id, :event_id => survival1.id, :episode_id => episode1.id)
point7 = Point.create!(:contestant_id => cont7.id, :event_id => survival1.id, :episode_id => episode1.id)
point8 = Point.create!(:contestant_id => cont17.id, :event_id => survival1.id, :episode_id => episode1.id)
point9 = Point.create!(:contestant_id => cont19.id, :event_id => survival1.id, :episode_id => episode1.id)
point10 = Point.create!(:contestant_id => cont24.id, :event_id => survival1.id, :episode_id => episode1.id)
point11 = Point.create!(:contestant_id => cont23.id, :event_id => survival1.id, :episode_id => episode1.id)
point12 = Point.create!(:contestant_id => cont15.id, :event_id => survival1.id, :episode_id => episode1.id)
point13 = Point.create!(:contestant_id => cont18.id, :event_id => survival1.id, :episode_id => episode1.id)
point14 = Point.create!(:contestant_id => cont11.id, :event_id => survival1.id, :episode_id => episode1.id)
point15 = Point.create!(:contestant_id => cont22.id, :event_id => survival1.id, :episode_id => episode1.id)
point16 = Point.create!(:contestant_id => cont20.id, :event_id => survival1.id, :episode_id => episode1.id)
point17 = Point.create!(:contestant_id => cont13.id, :event_id => survival1.id, :episode_id => episode1.id)
point18 = Point.create!(:contestant_id => cont21.id, :event_id => survival1.id, :episode_id => episode1.id)
point19 = Point.create!(:contestant_id => cont8.id, :event_id => survival1.id, :episode_id => episode1.id)
point20 = Point.create!(:contestant_id => cont15.id, :event_id => survival2.id, :episode_id => episode2.id)
point21 = Point.create!(:contestant_id => cont22.id, :event_id => survival2.id, :episode_id => episode2.id)
point22 = Point.create!(:contestant_id => cont10.id, :event_id => survival2.id, :episode_id => episode2.id)
point23 = Point.create!(:contestant_id => cont9.id, :event_id => survival2.id, :episode_id => episode2.id)
point24 = Point.create!(:contestant_id => cont8.id, :event_id => survival2.id, :episode_id => episode2.id)
point25 = Point.create!(:contestant_id => cont16.id, :event_id => survival2.id, :episode_id => episode2.id)
point26 = Point.create!(:contestant_id => cont17.id, :event_id => survival2.id, :episode_id => episode2.id)
point27 = Point.create!(:contestant_id => cont11.id, :event_id => survival2.id, :episode_id => episode2.id)
point28 = Point.create!(:contestant_id => cont14.id, :event_id => survival2.id, :episode_id => episode2.id)
point29 = Point.create!(:contestant_id => cont7.id, :event_id => survival2.id, :episode_id => episode2.id)
point30 = Point.create!(:contestant_id => cont20.id, :event_id => survival2.id, :episode_id => episode2.id)
point31 = Point.create!(:contestant_id => cont19.id, :event_id => survival2.id, :episode_id => episode2.id)
point32 = Point.create!(:contestant_id => cont12.id, :event_id => survival2.id, :episode_id => episode2.id)
point33 = Point.create!(:contestant_id => cont21.id, :event_id => survival2.id, :episode_id => episode2.id)
point34 = Point.create!(:contestant_id => cont13.id, :event_id => survival2.id, :episode_id => episode2.id)
point35 = Point.create!(:contestant_id => cont18.id, :event_id => survival2.id, :episode_id => episode2.id)
point36 = Point.create!(:contestant_id => cont23.id, :event_id => survival38.id, :episode_id => episode2.id)
point37 = Point.create!(:contestant_id => cont24.id, :event_id => survival38.id, :episode_id => episode2.id)
point38 = Point.create!(:contestant_id => cont25.id, :event_id => survival12.id, :episode_id => episode2.id)
point39 = Point.create!(:contestant_id => cont11.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont8.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont9.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont12.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont19.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont7.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont13.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont16.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont14.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont15.id, :event_id => survival3.id, :episode_id => episode3.id)
point40 = Point.create!(:contestant_id => cont17.id, :event_id => survival3.id, :episode_id => episode3.id)
point50 = Point.create!(:contestant_id => cont18.id, :event_id => survival3.id, :episode_id => episode3.id)
point51 = Point.create!(:contestant_id => cont10.id, :event_id => survival3.id, :episode_id => episode3.id)
point51 = Point.create!(:contestant_id => cont10.id, :event_id => survival3.id, :episode_id => episode3.id)
point52 = Point.create!(:contestant_id => cont20.id, :event_id => survival38.id, :episode_id => episode3.id)
point53 = Point.create!(:contestant_id => cont21.id, :event_id => survival38.id, :episode_id => episode3.id)
point54 = Point.create!(:contestant_id => cont22.id, :event_id => survival38.id, :episode_id => episode3.id)
point55 = Point.create!(:contestant_id => cont14.id, :event_id => survival4.id, :episode_id => episode4.id)
point56 = Point.create!(:contestant_id => cont12.id, :event_id => survival4.id, :episode_id => episode4.id)
point57 = Point.create!(:contestant_id => cont7.id, :event_id => survival4.id, :episode_id => episode4.id)
point58 = Point.create!(:contestant_id => cont10.id, :event_id => survival4.id, :episode_id => episode4.id)
point59 = Point.create!(:contestant_id => cont8.id, :event_id => survival4.id, :episode_id => episode4.id)
point60 = Point.create!(:contestant_id => cont11.id, :event_id => survival4.id, :episode_id => episode4.id)
point61 = Point.create!(:contestant_id => cont16.id, :event_id => survival4.id, :episode_id => episode4.id)
point62 = Point.create!(:contestant_id => cont9.id, :event_id => survival4.id, :episode_id => episode4.id)
point63 = Point.create!(:contestant_id => cont15.id, :event_id => survival4.id, :episode_id => episode4.id)
point64 = Point.create!(:contestant_id => cont17.id, :event_id => survival4.id, :episode_id => episode4.id)
point65 = Point.create!(:contestant_id => cont13.id, :event_id => survival4.id, :episode_id => episode4.id)
point66 = Point.create!(:contestant_id => cont18.id, :event_id => survival38.id, :episode_id => episode4.id)
point67 = Point.create!(:contestant_id => cont19.id, :event_id => survival38.id, :episode_id => episode4.id)
point68 = Point.create!(:contestant_id => cont8.id, :event_id => survival5.id, :episode_id => episode5.id)
point69 = Point.create!(:contestant_id => cont13.id, :event_id => survival5.id, :episode_id => episode5.id)
point70 = Point.create!(:contestant_id => cont12.id, :event_id => survival5.id, :episode_id => episode5.id)
point71 = Point.create!(:contestant_id => cont14.id, :event_id => survival5.id, :episode_id => episode5.id)
point72 = Point.create!(:contestant_id => cont7.id, :event_id => survival5.id, :episode_id => episode5.id)
point73 = Point.create!(:contestant_id => cont11.id, :event_id => survival5.id, :episode_id => episode5.id)
point74 = Point.create!(:contestant_id => cont9.id, :event_id => survival5.id, :episode_id => episode5.id)
point75 = Point.create!(:contestant_id => cont15.id, :event_id => survival5.id, :episode_id => episode5.id)
point76 = Point.create!(:contestant_id => cont10.id, :event_id => survival5.id, :episode_id => episode5.id)
point77 = Point.create!(:contestant_id => cont16.id, :event_id => survival38.id, :episode_id => episode5.id)
point78 = Point.create!(:contestant_id => cont17.id, :event_id => survival38.id, :episode_id => episode5.id)
point79 = Point.create!(:contestant_id => cont7.id, :event_id => survival6.id, :episode_id => episode6.id)
point80 = Point.create!(:contestant_id => cont11.id, :event_id => survival6.id, :episode_id => episode6.id)
point81 = Point.create!(:contestant_id => cont10.id, :event_id => survival6.id, :episode_id => episode6.id)
point82 = Point.create!(:contestant_id => cont8.id, :event_id => survival6.id, :episode_id => episode6.id)
point83 = Point.create!(:contestant_id => cont9.id, :event_id => survival6.id, :episode_id => episode6.id)
point84 = Point.create!(:contestant_id => cont12.id, :event_id => survival6.id, :episode_id => episode6.id)
point85 = Point.create!(:contestant_id => cont13.id, :event_id => survival38.id, :episode_id => episode6.id)
point86 = Point.create!(:contestant_id => cont14.id, :event_id => survival38.id, :episode_id => episode6.id)
point87 = Point.create!(:contestant_id => cont15.id, :event_id => survival38.id, :episode_id => episode6.id)
point88 = Point.create!(:contestant_id => cont8.id, :event_id => survival7.id, :episode_id => episode7.id)
point89 = Point.create!(:contestant_id => cont10.id, :event_id => survival7.id, :episode_id => episode7.id)
point90 = Point.create!(:contestant_id => cont7.id, :event_id => survival7.id, :episode_id => episode7.id)
point91 = Point.create!(:contestant_id => cont9.id, :event_id => survival7.id, :episode_id => episode7.id)
point92 = Point.create!(:contestant_id => cont11.id, :event_id => survival7.id, :episode_id => episode7.id)
point93 = Point.create!(:contestant_id => cont12.id, :event_id => survival38.id, :episode_id => episode7.id)
point94 = Point.create!(:contestant_id => cont9.id, :event_id => survival8.id, :episode_id => episode8.id)
point95 = Point.create!(:contestant_id => cont8.id, :event_id => survival8.id, :episode_id => episode8.id)
point96 = Point.create!(:contestant_id => cont7.id, :event_id => survival8.id, :episode_id => episode8.id)
point97 = Point.create!(:contestant_id => cont10.id, :event_id => survival38.id, :episode_id => episode8.id)
point98 = Point.create!(:contestant_id => cont8.id, :event_id => survival9.id, :episode_id => episode9.id)
point99 = Point.create!(:contestant_id => cont7.id, :event_id => survival9.id, :episode_id => episode9.id)
point100 = Point.create!(:contestant_id => cont9.id, :event_id => survival38.id, :episode_id => episode9.id)
point101 = Point.create!(:contestant_id => cont7.id, :event_id => survival10.id, :episode_id => episode10.id)
point102 = Point.create!(:contestant_id => cont8.id, :event_id => survival38.id, :episode_id => episode10.id)