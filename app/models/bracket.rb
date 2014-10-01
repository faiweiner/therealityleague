# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Bracket < League

end
