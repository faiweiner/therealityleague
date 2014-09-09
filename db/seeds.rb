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

season1 = Season.create(:name => 'Juan Pablo', :number => 18, :show_id => show1.id, :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.', :episode_count => 10)
season2 = Season.create(:name => 'Desiree', :number => 12, :show_id => show2.id, :premiere_date => two_weeks, :finale_date => two_weeks - 45, :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Repellat perspiciatis sequi culpa tempora et reprehenderit dolores, amet quos fugit numquam veritatis cupiditate fuga possimus ab sit alias, sunt, vitae. Iure.', :episode_count => 10)
season3 = Season.create(:name => 'Sean Lowe', :number => 17, :show_id => show1.id, :premiere_date => '01/07/2013', :finale_date => '01/12/2013', :description	=> 'The best bachelor ever - Sean Lowe is the man!', :image => '/assets/the_bachelor/logo.jpg', :episode_count => 10, :expired => true)

league1 = League.create(:name => 'The Best Public League', :commissioner_id => user1.id, :season_id => season2.id, :draft_type => 'Fantasy', :public_access => true)
league2 = League.create(:name => 'The Super Private League', :commissioner_id => user2.id, :season_id => season2.id, :draft_type => 'Fantasy', :public_access => false)
league3 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season1.id, :draft_type => 'Bracket', :public_access => false)
league4 = League.create(:name => 'Edelman\'s Bachelor League', :commissioner_id => user1.id, :season_id => season3.id, :draft_type => 'Bracket', :public_access => false)

league1.users << [user1, user2, user3]
league2.users << [user3, user4, user5]
league3.users << [user1, user4, user5]
league4.users << [user1, user2]

cont1 = Contestant.create(:name => 'Layla', :season_id => season1.id, :age => 22, :gender => 'Female', :occupation => 'Physical Therapist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis ullam doloribus, laborum asperiores aperiam.', :image => '/assets/the_bachelor/layla.jpg')
cont2 = Contestant.create(:name => 'Nikki', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Executive Assistant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Id quas sunt quam autem, itaque ducimus perferendis optio sint molestiae.', :image => '/assets/the_bachelor/nikki.jpg')
cont3 = Contestant.create(:name => 'Jessica', :season_id => season1.id, :age => 32, :gender => 'Female', :occupation => 'Nurse', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique cum repudiandae quod officia expedita tenetur praesentium magnam.', :image => '/assets/the_bachelor/jessica.jpg')
cont4 = Contestant.create(:name => 'Heather', :season_id => season1.id, :age => 26, :gender => 'Female', :occupation => 'Hair Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/heather.jpg')
cont5 = Contestant.create(:name => 'Alex', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Entrepreneur', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/alex.jpg')
cont6 = Contestant.create(:name => 'Suzie', :season_id => season1.id, :age => 24, :gender => 'Female', :occupation => 'Web Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sunt commodi, labore sequi maiores iusto accusamus laborum nostrum deleniti, odit reprehenderit, quas inventore!', :image => '/assets/the_bachelor/suzie.jpg')

cont7 = Contestant.create(:name => 'Catherine', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont8 = Contestant.create(:name => 'Lindsay', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Substitute Teacher', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont9 = Contestant.create(:name => 'AshLee', :season_id => season3.id, :age => 32, :gender => 'Female', :occupation => 'Personal Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont10 = Contestant.create(:name => 'Desiree', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Bridal Stylist', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont11 = Contestant.create(:name => 'Lesley M.', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Political Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont12 = Contestant.create(:name => 'Tierra', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Leasing Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont13 = Contestant.create(:name => 'Daniella', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Commercial Casting Associate', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont14 = Contestant.create(:name => 'Selma', :season_id => season3.id, :age => 29, :gender => 'Female', :occupation => 'Real Estate Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont15 = Contestant.create(:name => 'Sarah', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Advertising Executive', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont16 = Contestant.create(:name => 'Robyn', :season_id => season3.id, :age => 24, :gender => 'Female', :occupation => 'Oil Field Account Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont17 = Contestant.create(:name => 'Jackie', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Cosmetics Consultant', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont18 = Contestant.create(:name => 'Amanda', :season_id => season3.id, :age => 28, :gender => 'Female', :occupation => 'Fit Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont19 = Contestant.create(:name => 'Leslie H.', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Poker Dealer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont20 = Contestant.create(:name => 'Kristy', :season_id => season3.id, :age => 26, :gender => 'Female', :occupation => 'Model', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont21 = Contestant.create(:name => 'Taryn', :season_id => season3.id, :age => 30, :gender => 'Female', :occupation => 'Health Club Manager', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont22 = Contestant.create(:name => 'Kacie', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Community Organizer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont23 = Contestant.create(:name => 'Brooke', :season_id => season3.id, :age => 25, :gender => 'Female', :occupation => 'Graphic Designer', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont24 = Contestant.create(:name => 'Diana', :season_id => season3.id, :age => 31, :gender => 'Female', :occupation => 'Salon Owner', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')
cont25 = Contestant.create(:name => 'Katie', :season_id => season3.id, :age => 27, :gender => 'Female', :occupation => 'Yoga Instructor', :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit!', :image => '/assets/woman_placeholder.png')

roster1 = Bracket.create(:user_id => user1.id, :league_id => league3.id)
roster2 = Bracket.create(:user_id => user4.id, :league_id => league3.id)
roster3 = Bracket.create(:user_id => user5.id, :league_id => league3.id)
roster4 = Fantasy.create(:user_id => user3.id, :league_id => league2.id)
roster5 = Fantasy.create(:user_id => user4.id, :league_id => league2.id)
roster6 = Fantasy.create(:user_id => user5.id, :league_id => league2.id)
roster7 = Fantasy.create(:user_id => user1.id, :league_id => league1.id)
roster8 = Fantasy.create(:user_id => user2.id, :league_id => league1.id)
roster9 = Fantasy.create(:user_id => user3.id, :league_id => league1.id)

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
round11 = Round.create(:roster_id => roster10.id, :episode_id => episode6.id)
round12 = Round.create(:roster_id => roster10.id, :episode_id => episode7.id)
round13 = Round.create(:roster_id => roster10.id, :episode_id => episode8.id)
round14 = Round.create(:roster_id => roster10.id, :episode_id => episode9.id)
round15 = Round.create(:roster_id => roster10.id, :episode_id => episode10.id)



round6 = Round.create(:roster_id => roster11.id, :episode_id => episode1.id)
round6.contestants << roster11.contestants.clone
round7 = Round.create(:roster_id => roster11.id, :episode_id => episode2.id)
round7.contestants << round6.contestants.clone
round7.contestants.delete(cont13, cont16, cont23)
round8 = Round.create(:roster_id => roster11.id, :episode_id => episode3.id)
round8.contestants << round7.contestants.clone
round8.contestants.delete(cont19, cont20, cont21)
round9 = Round.create(:roster_id => roster11.id, :episode_id => episode4.id)
round9.contestants << round8.contestants.clone
round9.contestants.delete(cont8, cont17)
round10 = Round.create(:roster_id => roster11.id, :episode_id => episode5.id)
round10.contestants << round9.contestants.clone
round10.contestants.delete(cont7, cont10)

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

point1 = Point.create!(:contestant_id => cont7.id, :event_id => survival1.id, :episode_id => episode1.id)














