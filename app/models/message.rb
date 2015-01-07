# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  messagetype    :string(255)
#  messagecomment :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Message < ActiveRecord::Base
	belongs_to :user, inverse_of: :messages
end
