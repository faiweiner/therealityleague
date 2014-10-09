# == Schema Information
#
# Table name: seasons
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  number         :integer
#  show_id        :integer
#  premiere_date  :datetime
#  finale_date    :datetime
#  country_origin :string(255)
#  type           :string(255)
#  description    :text
#  episode_count  :integer
#  image          :string(255)
#  published      :boolean          default(FALSE)
#  expired        :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  website        :string(255)
#  network        :string(255)
#

require 'rails_helper'

RSpec.describe Season, :type => :model do
	# ---- associations ---- #
	it { is_expected.to belong_to(:show) }
	it { is_expected.to have_many(:leagues) }
	it { is_expected.to have_many(:events) }
	it { is_expected.to have_many(:contestants) }
	it { is_expected.to have_many(:episodes) }

	# ---- dummy data ---- #
	before do
		current_date = DateTime.now
		@show1 = Show.create(:name => 'The Bachelor', :image => '/assets/the_bachelor/logo.jpg')
		@season1 = Season.create(:name => 'Juan Pablo', :number => 18, :show_id => @show1.id, :premiere_date => '01/07/2014', :finale_date => '03/12/2014', :country_origin => 'USA', :description => 'With his Spanish accent, good looks, salsa moves and undying devotion for his daughter.', :episode_count => 10, :image => '/assets/the_bachelor/juanpablo.jpg', :published => true, :expired => :true)
		@season2 = Season.create(:name => 'Sean Lowe', :number => 17, :show_id => @show1.id, :premiere_date => '01/07/2013', :finale_date => '03/12/2013', :country_origin => 'USA', :description	=> 'The best bachelor ever - Sean Lowe is the man!', :episode_count => 10, :image => '/assets/the_bachelor/seanlowe.jpg', :published => true, :expired => :true)
		@season3 = Season.create(:name => '', :number => 0, :show_id => '', :premiere_date => '', :country_origin => '')
		@season4 = Season.create(:name => 'Xaun Babe', :number => 19, :show_id => @show1.id, :premiere_date => current_date + 7, :finale_date => current_date + 60, :country_origin => 'USA', :description => 'Fake Bachelor', :episode_count	=> 10, :published => true, :expired => :false)
	end

	# ---- general testing ---- #

	# name
	context 'name field' do 
		it 'should have a name' do
			expect(@season1.name).to eq 'Juan Pablo'
		end
		context	'when name is blank' do
			it { expect(@season3).to be_invalid }
		end
	end

	# number
	context 'number fiend' do
		it 'should have a number' do
			expect(@season1.number).to eq 18
		end

		context 'when number field is not specified' do
			it { expect(@season3).to be_invalid }
		end
	end

	# show_id
	context	'show_id' do
		it 'should have a show_id' do
			expect(@season1.show_id).to eq @show1.id
		end

		context 'when show_id is not specified' do
			it { expect(@season3).to be_invalid }
		end
	end

	# premiere_date
	context ''
end
