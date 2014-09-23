class PointsController < ApplicationController
	def index
		@points = Point.all
		@points_info_table = {}
		@points.each do |point|
			contestant = point.contestant.name
			event = generate_half_sentence(point.event.event)
			pts = point.event.points_asgn
			points_description = contestant + event
			@points_info_table[points_description] = pts
		end
	end

	def new
		
	end

	def create
		
	end

	def update
		
	end

	def delete
		
	end

	private

	def generate_half_sentence(string)
		string.gsub!("Contestant", "")
		return string
	end
end
