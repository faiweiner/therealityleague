# == Schema Information
#
# Table name: shows
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  premiere_date  :datetime
#  finale_date    :datetime
#  country_origin :string(255)
#  type           :string(255)
#  description    :text
#  episode_count  :integer
#  image          :string(255)
#  franchise_id   :integer
#  season         :integer
#  published      :boolean          default(FALSE)
#  expired        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

class Show < ActiveRecord::Base
	belongs_to :franchise, inverse_of: :shows
	has_many :leagues, inverse_of: :show, dependent: :destroy
	has_many :events, through: :franchise
	has_many :contestants
	has_many :episodes
	# belongs_to :score

	validates :name, :presence => true, :on => :create
	validates :premiere_date, :presence => true, :on => :create

	def self.top_three
		# This model method is called in Pages#home to give list of the three top shows
		
		Show.where(expired: false).order("premiere_date ASC").last(3)
	end

	def self.select_show
		# This model method is for populating Create League's drop-down menu
		@shows_list = Show.where(expired: false).each.map {|s| [s.name, s.id] } # FIXME! add a filter to only include the most recent show
	end

	def self.get_show_name(show_id)
		show = Show.find(show_id)
		show.name
	end

	# check method if show can be destroyed
	def destroyable?(show_id)
		show = Show.find(show_id)
		if show.expired == false
			if show.premiere_date < DateTime.now
				return true
			else
				return false
			end
		else
			return true
		end
	end

	# check method if show can be edited
	def editable?(show_id)
		show = Show.find(show_id)
		if show.expired == false
			return true
		end
	end
end
