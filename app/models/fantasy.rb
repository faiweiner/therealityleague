# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  commissioner_id :integer
#  season_id       :integer
#  public_access   :boolean          default(TRUE)
#  type            :string(255)
#  participant_cap :integer
#  draft_limit     :integer
#  draft_deadline  :datetime
#  draft_order     :string(255)
#  scoring_system  :integer
#  league_key      :string(255)
#  league_password :string(255)
#  active          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#

class Fantasy < League
	def self.model_name
		League.model_name
	end

	def gen_draft_limit
		self.draft_limit = self.season.contestants.count / self.participant_cap
	end

	def gen_draft_order
		draft_order = []
		draft_order = self.users.pluck(:id).shuffle
		self.draft_order = draft_order
	end

	private

	def set_draft_order
		if self.users.count <= self.participant_cap && self.draft_limit.present?
			gen_draft_order
		end
	end
end
