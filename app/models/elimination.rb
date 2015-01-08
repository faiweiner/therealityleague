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
#  locked          :boolean          default(FALSE)
#

class Elimination < League
	def self.model_name
		League.model_name
	end
end
