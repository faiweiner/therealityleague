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

bachelor19 = Season.create(
	:name => 'Chris Soules', 
	:number => 19, 
	:show_id => show1.id, 
	:premiere_date => '19/01/2015', 
	:finale_date => '09/03/2015', 
	:description => 'The bachelor with a heart of gold - This 6\'1\", blue-eyed bachelor loves football, camping and country music. He epitomizes what women look for in a man: successful, sensitive and sexy.', 
	:episode_count => 8, 
	:image => '/assets/the_bachelor/chrissoules.jpg', 
	:published => true,
	:website => 'http://abc.go.com/shows/the-bachelor',
	:network => 'ABC ©2015')

challenge26 = Season.create(
	:name => 'Battle of the Exes II',
	:number => 29,
	:show_id => challenge.id,
	:premiere_date => '20/01/2015',
	:finale_date => '17/03/2015',
	:description => 'The sequel to the show\'s 22nd season, Battle of the Exes.',
	:episode_count => 8,
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
	:draft_deadline => '18/01/2015',
	:scoring_system => 1)

league2 = Elimination.create(
	:name => 'Public Bachelor Elimination League', 
	:commissioner_id => user1.id, 
	:season_id => bachelor19.id, 
	:public_access => true,
	:type => 'Elimination',
	:draft_deadline => '18/01/2015',
	:scoring_system => 1)

league1.users << [user1]
league2.users << [user1]

bachelor19ep3 = Episode.create(:season_id => bachelor19.id, :air_date => '19/01/2015', :expected_survivors => 13)
bachelor19ep4 = Episode.create(:season_id => bachelor19.id, :air_date => '26/01/2015', :expected_survivors => 11)
bachelor19ep5 = Episode.create(:season_id => bachelor19.id, :air_date => '2/02/2015', :expected_survivors => 8)
bachelor19ep6 = Episode.create(:season_id => bachelor19.id, :air_date => '9/02/2015', :expected_survivors => 5)
bachelor19ep7 = Episode.create(:season_id => bachelor19.id, :air_date => '16/02/2015', :expected_survivors => 4)
bachelor19ep8 = Episode.create(:season_id => bachelor19.id, :air_date => '23/02/2015', :expected_survivors => 3)
bachelor19ep9 = Episode.create(:season_id => bachelor19.id, :air_date => '2/03/2015', :expected_survivors => 2)
bachelor19ep10 = Episode.create(:season_id => bachelor19.id, :air_date => '9/03/2015', :expected_survivors => 1)

challenge26ep3 = Episode.create(:season_id => challenge26.id, :air_date => '19/01/2015', :expected_survivors => 18)
challenge26ep4 = Episode.create(:season_id => challenge26.id, :air_date => '27/01/2015', :expected_survivors => 16)
challenge26ep5 = Episode.create(:season_id => challenge26.id, :air_date => '3/02/2015', :expected_survivors => 14)
challenge26ep6 = Episode.create(:season_id => challenge26.id, :air_date => '10/02/2015', :expected_survivors => 12)
challenge26ep7 = Episode.create(:season_id => challenge26.id, :air_date => '17/02/2015', :expected_survivors => 10)
challenge26ep8 = Episode.create(:season_id => challenge26.id, :air_date => '24/02/2015', :expected_survivors => 8)
challenge26ep9 = Episode.create(:season_id => challenge26.id, :air_date => '3/03/2015', :expected_survivors => 6)
challenge26ep10 = Episode.create(:season_id => challenge26.id, :air_date => '10/03/2015', :expected_survivors => 2)

bachelor19cont3 = Contestant.create(:name =>'Amber', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/amber.jpg', :occupation => 'Bartender', :description => 'Hometown: Chicago, IL')
bachelor19cont4 = Contestant.create(:name =>'Ashley I.', :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/ashleyi.jpg', :occupation => 'Freelance Journalist', :description => 'Hometown: Wayne, NJ')
bachelor19cont5 = Contestant.create(:name =>'Ashley S.', :season_id => bachelor19.id, :age => 24, :gender => 'female', :image => '/assets/the_bachelor/season19/ashleys.jpg', :occupation => 'Hair Stylist', :description => 'Hometown: Brooklyn, NY')
bachelor19cont6 = Contestant.create(:name =>'Becca', :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/becca.jpg', :occupation => 'Chiropractic Assistant', :description => 'Hometown: San Diego, CA')
bachelor19cont8 = Contestant.create(:name =>'Britt', :season_id => bachelor19.id, :age => 27, :gender => 'female', :image => '/assets/the_bachelor/season19/britt.jpg', :occupation => 'Waitress', :description => 'Hometown: Hollywood, CA')
bachelor19cont10 = Contestant.create(:name =>'Carly', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/carly.jpg', :occupation => 'Cruise Ship Singer', :description => 'Hometown: Arlington, TX')
bachelor19cont11 = Contestant.create(:name =>'Jade', :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/jade.jpg', :occupation => 'Cosmetics Developer', :description => 'Hometown: Los Angeles, CA')
bachelor19cont12 = Contestant.create(:name =>'Jillian', :season_id => bachelor19.id, :age => 25, :gender => 'female', :image => '/assets/the_bachelor/season19/jillian.jpg', :occupation => ' News Producer', :description => 'Hometown: Washington, D.C.')
bachelor19cont13 = Contestant.create(:name =>'Juelia', :season_id => bachelor19.id, :age => 30, :gender => 'female', :image => '/assets/the_bachelor/season19/juelia.jpg', :occupation => 'Esthetician', :description => 'Hometown: Portland, OR')
bachelor19cont15 = Contestant.create(:name =>'Kaitlyn', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/kaitlyn.jpg', :occupation => 'Dance Instructor', :description => 'Hometown: Vancouver, BC')
bachelor19cont17 = Contestant.create(:name =>'Kelsey', :season_id => bachelor19.id, :age => 28, :gender => 'female', :image => '/assets/the_bachelor/season19/kelsey.jpg', :occupation => 'Guidance Counselor', :description => 'Hometown: Austin, TX')
bachelor19cont19 = Contestant.create(:name =>'Mackenzie', :season_id => bachelor19.id, :age => 21, :gender => 'female', :image => '/assets/the_bachelor/season19/mackenzie.jpg', :occupation => 'Dental Assistant', :description => 'Hometown: Maple Valley, WA')
bachelor19cont20 = Contestant.create(:name =>'Megan', :season_id => bachelor19.id, :age => 23, :gender => 'female', :image => '/assets/the_bachelor/season19/megan.jpg', :occupation => 'Make-Up Artist', :description => 'Hometown: Nashville, TN')
bachelor19cont23 = Contestant.create(:name =>'Nikki', :season_id => bachelor19.id, :age => 26, :gender => 'female', :image => '/assets/the_bachelor/season19/nikki.jpg', :occupation => 'Former NFL Cheerleader', :description => 'Hometown: New York City, NY')
bachelor19cont25 = Contestant.create(:name =>'Samantha', :season_id => bachelor19.id, :age => 27, :gender => 'female', :image => '/assets/the_bachelor/season19/samantha.jpg', :occupation => 'Fashion Designer', :description => 'Hometown: Los Angeles, CA')
bachelor19cont28 = Contestant.create(:name =>'Tracy', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/tracy.jpg', :occupation => 'Fourth Grade Teacher', :description => 'Hometown: Wellington, FL')
bachelor19cont29 = Contestant.create(:name =>'Trina', :season_id => bachelor19.id, :age => 33, :gender => 'female', :image => '/assets/the_bachelor/season19/trina.jpg', :occupation => 'Special Education Teacher', :description => 'Hometown: San Clemente, CA')
bachelor19cont30 = Contestant.create(:name =>'Whitney', :season_id => bachelor19.id, :age => 29, :gender => 'female', :image => '/assets/the_bachelor/season19/whitney.jpg', :occupation => 'Fertility Nurse', :description => 'Hometown: Chicago, IL')

botxiicont1 = Contestant.create(:name => 'Adam Kuhn', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/adam.gif', :occupation => 'AYTO?: Hawaii', :description => '')
botxiicont2 = Contestant.create(:name => 'Averey Tressler', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/averey.gif', :occupation => 'RW: Portland', :description => '')
botxiicont3 = Contestant.create(:name => 'Brittany Baldassari', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/brittany.gif', :occupation => 'AYTO?: Hawaii', :description => '')
botxiicont4 = Contestant.create(:name => 'Chris "CT" Tamburello', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/ct.gif', :occupation => 'RW: Paris', :description => '')
botxiicont5 = Contestant.create(:name => 'Diem Brown', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/diem.gif', :occupation => 'Fresh Meat', :description => '')
botxiicont6 = Contestant.create(:name => 'Dustin Zito', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/dustin.gif', :occupation => 'RW: Las Vegas (2011)', :description => '')
botxiicont7 = Contestant.create(:name => 'Hailey Chivers', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/hailey.gif', :occupation => 'RW: Ex-Plosion', :description => '')
botxiicont8 = Contestant.create(:name => 'Jay Gotti', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/jay.gif', :occupation => 'RW: Ex-Plosion', :description => '')
botxiicont9 = Contestant.create(:name => 'Jemmye Carroll', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/jemmye.gif', :occupation => 'RW: New Orleans (2010)', :description => '')
botxiicont10 = Contestant.create(:name => 'Jenna Compono', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/jenna.gif', :occupation => 'RW: Ex-Plosion', :description => '')
botxiicont11 = Contestant.create(:name => 'Jessica McCain', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/jessica.gif', :occupation => 'RW: Portland', :description => '')
botxiicont12 = Contestant.create(:name => 'John "JJ" Jacobs', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/jj.gif', :occupation => 'AYTO?: Hawaii', :description => '')
botxiicont13 = Contestant.create(:name => 'Johnny Devenanzio', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/johnnyd.gif', :occupation => 'RW: Key West', :description => '')
botxiicont14 = Contestant.create(:name => 'Johnny Reilly', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/bananas.gif', :occupation => 'RW: Portland', :description => '')
botxiicont15 = Contestant.create(:name => 'Jonna Mannion', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/jonna.gif', :occupation => 'RW: Cancun', :description => '')
botxiicont16 = Contestant.create(:name => 'Jordan Wiseley', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/jordan.gif', :occupation => 'RW: Portland', :description => '')
botxiicont17 = Contestant.create(:name => 'Leroy Garrett', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/leroy.gif', :occupation => 'RW: Las Vegas (2011)', :description => '')
botxiicont18 = Contestant.create(:name => 'Nany González', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/nany.gif', :occupation => 'RW: Las Vegas (2011)', :description => '')
botxiicont19 = Contestant.create(:name => 'Nia Moore', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/nia.gif', :occupation => 'RW: Portland', :description => '')
botxiicont20 = Contestant.create(:name => 'Ryan Knight', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/knight.gif', :occupation => 'RW: New Orleans (2010)', :description => '')
botxiicont21 = Contestant.create(:name => 'Sarah Rice', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/sarah.gif', :occupation => 'RW: Brooklyn', :description => '')
botxiicont22 = Contestant.create(:name => 'Simone Kelly', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/simone.gif', :occupation => 'AYTO?: Hawaii', :description => '')
botxiicont23 = Contestant.create(:name => 'Theresa González', :season_id => challenge26.id, :age => 25, :gender => 'female', :image => '/assets/the_challenge/botxii/theresa.gif', :occupation => 'Fresh Meat II', :description => '')
botxiicont24 = Contestant.create(:name => 'Thomas Buell', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/thomas.gif', :occupation => 'RW: Ex-Plosion', :description => '')
botxiicont25 = Contestant.create(:name => 'Wes Bergmann', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/wes.gif', :occupation => 'RW: Austin', :description => '')
botxiicont26 = Contestant.create(:name => 'Zach Nichols', :season_id => challenge26.id, :age => 25, :gender => 'male', :image => '/assets/the_challenge/botxii/zach.gif', :occupation => 'RW: San Diego (2011)', :description => '')

roster1 = Roster.create(:user_id => user1.id, :league_id => league1.id)
roster2 = Roster.create(:user_id => user1.id, :league_id => league2.id)

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
survival22 = Survival.create(:show_id => show1.id, :description => 'Gets eliminated', :points_asgn => 0)
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

botxii1a = Competition.create(:show_id => challenge.id, :description =>'Wins the Power Couple mission', :points_asgn => 30)
botxii1b = Competition.create(:show_id => challenge.id, :description =>'Selected to compete in the Dome', :points_asgn => 10)
botxii3a = Competition.create(:show_id => challenge.id, :description =>'Wins in the Dome', :points_asgn => 20)
botxii3b = Competition.create(:show_id => challenge.id, :description =>'Loses in the Dome', :points_asgn => -10)
botxii4 = Competition.create(:show_id => challenge.id, :description =>'Chosen through public vote to face a random opponent in the Ex-ile', :points_asgn => 15)
botxii5 = Competition.create(:show_id => challenge.id, :description =>'Randomly selected to compete in the Ex-ile', :points_asgn => 10)
botxii6 = Competition.create(:show_id => challenge.id, :description =>'Wins in the Ex-ile, allowed to return to the game', :points_asgn => 20)
botxii7 = Competition.create(:show_id => challenge.id, :description =>'Loses in the Ex-ile, forced to leave the game', :points_asgn => -20)
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
botxii33 = Survival.create(:show_id => challenge.id, :description =>'Departs early outside of the Ex-ile challenge. Usually due to injury or quitting', :points_asgn => 50)
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