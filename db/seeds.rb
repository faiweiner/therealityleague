User.destroy_all
League.destroy_all
Roster.destroy_all
Round.destroy_all

Show.destroy_all
Event.destroy_all
Season.destroy_all
Episode.destroy_all
Contestant.destroy_all

Elimination.destroy_all
Fantasy.destroy_all

Scheme.destroy_all
Altercation.destroy_all
Competition.destroy_all
Debauchery.destroy_all
Extracurricular.destroy_all
Survival.destroy_all

user1 = User.create(:email => 'faiweiner@gmail.com', :username => 'faiweiner', :avatar => 'http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png', :password => 'chicken', :password_confirmation => 'chicken', :admin => true)

show1 = Show.create(:name => 'The Bachelor', :image => '/assets/the_bachelor/logo.jpg')
challenge = Show.create(:name => 'The Challenge', :image => '/assets/the_challenge/thechallenge.jpg')

season1 = Season.create(
	:name => 'Juan Pablo', 
	:number => 18, 
	:show_id => show1.id, 
	:premiere_date => '05/01/2014',
	:finale_date => '10/03/2014', 
	:description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter, Juan Pablo, 32, was a fan favorite. Sadly, Desiree Hartsock couldn\'t see a future with Juan Pablo and sent him home from Barcelona.', 
	:episode_count => 10, 
	:image => '/assets/the_bachelor/juanpablo.jpg', 
	:published => true,
	:website => 'http://abc.go.com/shows/the-bachelor',
	:network => 'ABC ©2014',
	:expired => true)

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
	:website => 'http://abc.go.com/shows/the-bachelor',
	:network => 'ABC ©2013',
	:expired => true)

bachelor19 = Season.create(
	:name => 'Chris Soules', 
	:number => 19, 
	:show_id => show1.id, 
	:premiere_date => '05/01/2015', 
	:finale_date => '09/03/2015', 
	:description => 'The bachelor with a heart of gold - This 6\'1\", blue-eyed bachelor loves football, camping and country music. He epitomizes what women look for in a man: successful, sensitive and sexy.', 
	:episode_count => 10, 
	:image => '/assets/the_bachelor/chrissoules.jpg', 
	:published => true,
	:website => 'http://abc.go.com/shows/the-bachelor',
	:network => 'ABC ©2015')

challenge26 = Season.create(
	:name => 'Battle of the Exes II',
	:number => 29,
	:show_id => challenge.id,
	:premiere_date => '06/01/2015',
	:finale_date => '17/03/2015',
	:description => 'The sequel to the show\'s 22nd season, Battle of the Exes.',
	:episode_count => 12,
	:image => '/assets/survivor/29/logo.png',
	:published => true,
	:website => '',
	:network => 'MTV ©2015')

league1 = Fantasy.create(
	:name => 'Public Bachelor Fantasy League', 
	:commissioner_id => user1.id, 
	:season_id => bachelor19.id, 
	:public_access => true,
	:type => 'Fantasy', 
	:draft_limit => 5,
	:scoring_system => 1)

league2 = Elimination.create(
	:name => 'Public Bachelor Elimination League', 
	:commissioner_id => user1.id, 
	:season_id => bachelor19.id, 
	:type => 'Elimination', 
	:scoring_system => 1)

league1.users << [user1]
league2.users << [user1]


bachelor19ep1 = Episode.create(:season_id => bachelor19.id, :air_date => '05/01/2015')
bachelor19ep2 = Episode.create(:season_id => bachelor19.id, :air_date => '12/01/2015')
bachelor19ep3 = Episode.create(:season_id => bachelor19.id, :air_date => '19/01/2015')
bachelor19ep4 = Episode.create(:season_id => bachelor19.id, :air_date => '26/01/2015')
bachelor19ep5 = Episode.create(:season_id => bachelor19.id, :air_date => '2/02/2015')
bachelor19ep6 = Episode.create(:season_id => bachelor19.id, :air_date => '9/02/2015')
bachelor19ep7 = Episode.create(:season_id => bachelor19.id, :air_date => '16/02/2015')
bachelor19ep8 = Episode.create(:season_id => bachelor19.id, :air_date => '23/02/2015')
bachelor19ep9 = Episode.create(:season_id => bachelor19.id, :air_date => '2/03/2015')
bachelor19ep10 = Episode.create(:season_id => bachelor19.id, :air_date => '9/03/2015')

bachelor19cont1 = Contestant.create(:name =>'Alissa', :season_id => bachelor19.id, :age => 24, :gender => 'female', :image => '/assets/the_bachelor/season19/alissa.jpg', :occupation => 'Flight Attendant', :description => 'Hometown: Hamilton, NJ')
bachelor19cont2 = Contestant.create(:name =>'Amanda', present: false, :season_id => bachelor19.id, :age => 24, :gender => 'female', :image => '/assets/the_bachelor/season19/amanda.jpg', :occupation => 'Ballet Teacher', :description => 'Hometown: Lake in the Hills, IL')
bachelor19cont3 = Contestant.create(:name =>'Amber', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/amber.jpg', :occupation => 'Bartender', :description => 'Hometown: Chicago, IL')
bachelor19cont4 = Contestant.create(:name =>'Ashley I.', :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/ashleyi.jpg', :occupation => 'Freelance Journalist', :description => 'Hometown: Wayne, NJ')
bachelor19cont5 = Contestant.create(:name =>'Ashley S.', :season_id => bachelor19.id, :age => 24, :gender => 'female', :image => '/assets/the_bachelor/season19/ashleys.jpg', :occupation => 'Hair Stylist', :description => 'Hometown: Brooklyn, NY')
bachelor19cont6 = Contestant.create(:name =>'Becca', :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/becca.jpg', :occupation => 'Chiropractic Assistant', :description => 'Hometown: San Diego, CA')
bachelor19cont7 = Contestant.create(:name =>'Bo', :present => false, :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/bo.jpg', :occupation => 'Plus-Size Model', :description => 'Hometown: Carpinteria, CA')
bachelor19cont8 = Contestant.create(:name =>'Britt', :season_id => bachelor19.id, :age => 27, :gender => 'female', :image => '/assets/the_bachelor/season19/britt.jpg', :occupation => 'Waitress', :description => 'Hometown: Hollywood, CA')
bachelor19cont9 = Contestant.create(:name =>'Brittany', :present => false, :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/brittany.jpg', :occupation => 'WWE Diva-in-Training', :description => 'Hometown: Orlando, FL')
bachelor19cont10 = Contestant.create(:name =>'Carly', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/carly.jpg', :occupation => 'Cruise Ship Singer', :description => 'Hometown: Arlington, TX')
bachelor19cont11 = Contestant.create(:name =>'Jade', :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/jade.jpg', :occupation => 'Cosmetics Developer', :description => 'Hometown: Los Angeles, CA')
bachelor19cont12 = Contestant.create(:name =>'Jillian', :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/jillian.jpg', :occupation => ' News Producer', :description => 'Hometown: Washington, D.C.')
bachelor19cont13 = Contestant.create(:name =>'Juelia', :season_id => bachelor19.id, :age => 30, :gender => 'female', :image => '/assets/the_bachelor/season19/juelia.jpg', :occupation => 'Esthetician', :description => 'Hometown: Portland, OR')
bachelor19cont14 = Contestant.create(:name =>'Jordan', :season_id => bachelor19.id, :age => 24, :gender => 'female', :image => '/assets/the_bachelor/season19/jordan.jpg', :occupation => 'Student', :description => 'Hometown: Windsor, CO')
bachelor19cont15 = Contestant.create(:name =>'Kaitlyn', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/kaitlyn.jpg', :occupation => 'Dance Instructor', :description => 'Hometown: Vancouver, BC')
bachelor19cont16 = Contestant.create(:name =>'Kara', :present => false, :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/kara.jpg', :occupation => 'High School Soccer Coach', :description => 'Hometown: Brownsville, KY')
bachelor19cont17 = Contestant.create(:name =>'Kelsey', :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/kelsey.jpg', :occupation => 'Guidance Counselor', :description => 'Hometown: Austin, TX')
bachelor19cont18 = Contestant.create(:name =>'Kimberly', :present => false, :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/kimberly.jpg', :occupation => 'Yoga Instructor', :description => 'Hometown: Long Island, NY')
bachelor19cont19 = Contestant.create(:name =>'Mackenzie', :season_id => bachelor19.id, :age => 21, :gender => 'female', :image => '/assets/the_bachelor/season19/mackenzie.jpg', :occupation => 'Dental Assistant', :description => 'Hometown: Maple Valley, WA')
bachelor19cont20 = Contestant.create(:name =>'Megan', :season_id => bachelor19.id, :age => 23, :gender => 'female', :image => '/assets/the_bachelor/season19/megan.jpg', :occupation => 'Make-Up Artist', :description => 'Hometown: Nashville, TN')
bachelor19cont21 = Contestant.create(:name =>'Michelle', :present => false, :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/michelle.jpg', :occupation => 'Wedding Cake Decorator', :description => 'Hometown: Provo, UT')
bachelor19cont22 = Contestant.create(:name =>'Nicole', :present => false, :season_id => bachelor19.id, :age => 31, :gender => 'female', :image => '/assets/the_bachelor/season19/nicole.jpg', :occupation => 'Real Estate Agent', :description => 'Hometown: Scottsdale, AZ')
bachelor19cont23 = Contestant.create(:name =>'Nikki', :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/nikki.jpg', :occupation => 'Former NFL Cheerleader', :description => 'Hometown: New York City, NY')
bachelor19cont24 = Contestant.create(:name =>'Reegan', :present => false, :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/reegan.jpg', :occupation => 'Cadaver Tissue Saleswoman', :description => 'Hometown: Manhattan Beach, CA')
bachelor19cont25 = Contestant.create(:name =>'Samantha', :season_id => bachelor19.id, :age => 27, :gender => 'female', :image => '/assets/the_bachelor/season19/samantha.jpg', :occupation => 'Fashion Designer', :description => 'Hometown: Los Angeles, CA')
bachelor19cont26 = Contestant.create(:name =>'Tandra', :season_id => bachelor19.id, :age => 30, :gender => 'female', :image => '/assets/the_bachelor/season19/tandra.jpg', :occupation => 'Executive Assistant', :description => 'Hometown: Sandy UT')
bachelor19cont27 = Contestant.create(:name =>'Tara', :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/tara.jpg', :occupation => 'Sport Fishing Enthusiast', :description => 'Hometown: Ft. Lauderdale, FL')
bachelor19cont28 = Contestant.create(:name =>'Tracy', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/tracy.jpg', :occupation => 'Fourth Grade Teacher', :description => 'Hometown: Wellington, FL')
bachelor19cont29 = Contestant.create(:name =>'Trina', :season_id => bachelor19.id, :age => 33, :gender => 'female', :image => '/assets/the_bachelor/season19/trina.jpg', :occupation => 'Special Education Teacher', :description => 'Hometown: San Clemente, CA')
bachelor19cont30 = Contestant.create(:name =>'Whitney', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/whitney.jpg', :occupation => 'Fertility Nurse', :description => 'Hometown: Chicago, IL')

roster1 = Roster.create(:user_id => user1.id, :league_id => league1.id)
roster2 = Roster.create(:user_id => user1.id, :league_id => league2.id)

roster1.contestants << [bachelor19cont4, bachelor19cont7, bachelor19cont15, bachelor19cont18, bachelor19cont26]

survival1 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 1', :points_asgn => 10)
survival2 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 2', :points_asgn => 20)
survival3 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 3', :points_asgn => 30)
survival4 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 4', :points_asgn => 40)
survival5 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 5', :points_asgn => 50)
survival6 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 6', :points_asgn => 60)
survival7 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 7', :points_asgn => 70)
survival8 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 8', :points_asgn => 80)
survival9 = Survival.create(:show_id => show1.id, :description => 'Receives a rose in Week 9', :points_asgn => 90)
survival10 = Survival.create(:show_id => show1.id, :description => 'Receives the Final Rose', :points_asgn => 100)
survival11 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 1', :points_asgn => 10)
survival12 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 2', :points_asgn => 10)
survival13 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 3', :points_asgn => 10)
survival14 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 4', :points_asgn => 10)
survival15 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 5', :points_asgn => 10)
survival16 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 6', :points_asgn => 10)
survival17 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 7', :points_asgn => 10)
survival18 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 8', :points_asgn => 10)
survival19 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in Week 9', :points_asgn => 10)
survival20 = Survival.create(:show_id => show1.id, :description => 'Leaves on her own accord in the Finale', :points_asgn => 10)
survival21 = Survival.create(:show_id => show1.id, :description => 'Is asked to leave by the producer', :points_asgn => 100)
game22 = Competition.create(:show_id => show1.id, :description => 'Is chosen for 1-on-1 date', :points_asgn => 50)
game23 = Competition.create(:show_id => show1.id, :description => 'Is chosen for group date', :points_asgn => 25)
game24 = Competition.create(:show_id => show1.id, :description => 'Gets in a helicopter', :points_asgn => 25)
game25 = Competition.create(:show_id => show1.id, :description => 'Gets a Fantasy Suite invitation', :points_asgn => 75)
game26 = Competition.create(:show_id => show1.id, :description => 'Rejects a Fantay Suite invitation', :points_asgn => 100)
game27 = Competition.create(:show_id => show1.id, :description => 'Meets the bachelor\'s family', :points_asgn => 50)
game28 = Competition.create(:show_id => show1.id, :description => 'Wins a challenge', :points_asgn => 25)
game29 = Competition.create(:show_id => show1.id, :description => 'Loses a challenge', :points_asgn => -5)
extra30 = Extracurricular.create(:show_id => show1.id, :description => 'Kisses the bachelor on the lips', :points_asgn => 10)
extra31 = Extracurricular.create(:show_id => show1.id, :description => 'Gets in the hot tub with the bachelor', :points_asgn => 20)
extra32 = Extracurricular.create(:show_id => show1.id, :description => 'Cries', :points_asgn => 10)
extra33 = Extracurricular.create(:show_id => show1.id, :description => 'Gets in a fight with another contestant', :points_asgn => 25)
extra34 = Extracurricular.create(:show_id => show1.id, :description => 'Says she\'s "here for the right reason" ', :points_asgn => 15)
extra35 = Extracurricular.create(:show_id => show1.id, :description => 'Gets inappropriately drunk', :points_asgn => 25)
extra36 = Extracurricular.create(:show_id => show1.id, :description => 'Gets injured', :points_asgn => 25)
extra37 = Extracurricular.create(:show_id => show1.id, :description => 'Gives the bachelor a gift', :points_asgn => 10)
survival38 = Survival.create(:show_id => show1.id, :description => 'Gets eliminated', :points_asgn => 0)

botxii1 = Competition.create(:show_id => challenge.id, :description =>'Wins a challenge, resulting in an immunity', :points_asgn => 20)
botxii2 = Competition.create(:show_id => challenge.id, :description =>'Wins a challenge, resulting in a cash prize', :points_asgn => 10)
botxii3 = Competition.create(:show_id => challenge.id, :description =>'Loses a challenge', :points_asgn => -10)
botxii4 = Competition.create(:show_id => challenge.id, :description =>'Chosen through public vote to face a random opponent in the elimination', :points_asgn => 15)
botxii5 = Competition.create(:show_id => challenge.id, :description =>'Randomly selects the "kill card" during the Draw to compete in the elimination challenge', :points_asgn => 10)
botxii6 = Competition.create(:show_id => challenge.id, :description =>'Wins an elimination, allowed to return to the game', :points_asgn => 5)
botxii7 = Competition.create(:show_id => challenge.id, :description =>'Loses an elimination, forced to leave the game', :points_asgn => 20)
botxii8 = Competition.create(:show_id => challenge.id, :description =>'Serious injury resulting in genuine concern or requiring a medic or ambulance', :points_asgn => 10)
botxii9 = Competition.create(:show_id => challenge.id, :description =>'Visible mark, wound or contusion, or a well documented internal injury', :points_asgn => 20)
botxii10 = Competition.create(:show_id => challenge.id, :description =>'Throws a challenge', :points_asgn => 10)
botxii11 = Competition.create(:show_id => challenge.id, :description =>'Refuses a challenge', :points_asgn => 20)
botxii12 = Competition.create(:show_id => challenge.id, :description =>'Gets berated by host', :points_asgn => 20)
botxii13 = Competition.create(:show_id => challenge.id, :description =>'Recipient of vocal disappointment or anger stemming from host T.J. Lavin. Generally due to a lack of effort or bush league behavior', :points_asgn => -10)
botxii14 = Competition.create(:show_id => challenge.id, :description =>'“You Killed It”, the highest praise an individual or group can receive', :points_asgn => 25)
botxii15 = Competition.create(:show_id => challenge.id, :description =>'First place team(s), awarded to each member of both genders', :points_asgn => 100)
botxii16 = Competition.create(:show_id => challenge.id, :description =>'Second place team(s), awarded to each member of both genders', :points_asgn => 50)
botxii17 = Competition.create(:show_id => challenge.id, :description =>'Does NOT complete the final mission', :points_asgn => 25)
botxii18 = Altercation.create(:show_id => challenge.id, :description =>'Yelling, negative language, or extreme nonviolent behavior directed at another', :points_asgn => 5)
botxii19 = Altercation.create(:show_id => challenge.id, :description =>'Encroaching on ones personal space and getting right up in one’s face without crossing the line into a physical altercation', :points_asgn => 10)
botxii20 = Altercation.create(:show_id => challenge.id, :description =>'Any altercation where violent behavior or physical contact in the form of grappling, hair pulling, or shoving occurs. Usually resulting in a third party interjecting', :points_asgn => 20)
botxii21 = Altercation.create(:show_id => challenge.id, :description =>'Engaging in any activity that could be considered a "hate crime" or anything that could be considered racist, sexist, or homophobic', :points_asgn => 20)
botxii22 = Altercation.create(:show_id => challenge.id, :description =>'Being accused of a "hate crime" or anything that could be considered racist, sexist, or homophobic, without having actually committed the act', :points_asgn => 5)
botxii23 = Altercation.create(:show_id => challenge.id, :description =>'Crying or showing extreme saddened and distraught emotion', :points_asgn => -5)
botxii24 = Altercation.create(:show_id => challenge.id, :description =>'Inducing crying (deliberately and indeliberately)', :points_asgn => 10)
botxii25 = Altercation.create(:show_id => challenge.id, :description =>'Throwing a drink or harmless object at another individual i.e. pillow', :points_asgn => 10)
botxii26 = Altercation.create(:show_id => challenge.id, :description =>'Throwing an object that results in the destruction of property i.e. trash can', :points_asgn => 10)
botxii27 = Altercation.create(:show_id => challenge.id, :description =>'Throwing a punch that results in the destruction of property i.e. punching a wall', :points_asgn => 10)
botxii28 = Altercation.create(:show_id => challenge.id, :description =>'Throwing a harmful object at another individual i.e. glass bottle', :points_asgn => 20)
botxii29 = Altercation.create(:show_id => challenge.id, :description =>'Throwing a punch or slap at another individual with intent to harm', :points_asgn => 20)
botxii30 = Altercation.create(:show_id => challenge.id, :description =>'Gets restrained by other contestants', :points_asgn => 5)
botxii31 = Altercation.create(:show_id => challenge.id, :description =>'Restrains other contestants', :points_asgn => 10)
botxii32 = Altercation.create(:show_id => challenge.id, :description =>'Fights with non-cast members on camera', :points_asgn => 25)
botxii33 = Survival.create(:show_id => challenge.id, :description =>'Departs early outside of an elimination challenge. Usually due to injury or quitting', :points_asgn => 50)
botxii34 = Survival.create(:show_id => challenge.id, :description =>'Forcibly kicked off for unsavory acts and reasons other than game play', :points_asgn => 100)
botxii35 = Altercation.create(:show_id => challenge.id, :description =>'Gets kicked off the show as a result of an altercation', :points_asgn => 50)
botxii36 = Debauchery.create(:show_id => challenge.id, :description =>'Dresses in costume', :points_asgn => 5)
botxii37 = Debauchery.create(:show_id => challenge.id, :description =>'Engages in self-promotion', :points_asgn => 10)
botxii38 = Debauchery.create(:show_id => challenge.id, :description =>'Vomits', :points_asgn => 10)
botxii39 = Debauchery.create(:show_id => challenge.id, :description =>'Blurcle (nudity)', :points_asgn => 10)
botxii40 = Debauchery.create(:show_id => challenge.id, :description =>'Quickly kisses or pecks on the face or head', :points_asgn => 5)
botxii41 = Debauchery.create(:show_id => challenge.id, :description =>'Open mouth kisses or auditory slurping noises, such that kissing can be inferred', :points_asgn => 10)
botxii42 = Debauchery.create(:show_id => challenge.id, :description =>'Makes out with member of the same sex', :points_asgn => 15)
botxii43 = Debauchery.create(:show_id => challenge.id, :description =>'Engages in a three-way kiss', :points_asgn => 20)
botxii44 = Debauchery.create(:show_id => challenge.id, :description =>'Has sex with another contestant', :points_asgn => 20)
botxii45 = Debauchery.create(:show_id => challenge.id, :description =>'Denies having sex with another contestant', :points_asgn => 10)
botxii46 = Debauchery.create(:show_id => challenge.id, :description =>'Mentions key phrase(s)', :points_asgn => 10)
botxii47 = Debauchery.create(:show_id => challenge.id, :description =>'Receives a subtitle on screen', :points_asgn => 5)