# == Schema Information
#
# Table name: shows
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  premiere_date  :datetime
#  country_origin :string(255)
#  type           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  description    :text
#  image          :string(255)
#  series_id      :integer
#  expired        :boolean          default(FALSE)
#  episode_count  :integer
#  finale_date    :datetime
#  shows          :string(255)
#

class Show < ActiveRecord::Base
	has_many :leagues, inverse_of: :show, dependent: :destroy
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

  def self.expired
  	
  end
end
