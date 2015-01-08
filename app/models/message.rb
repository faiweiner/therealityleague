# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  messagetype    :string(255)
#  messagecomment :text
#  created_at     :datetime
#  updated_at     :datetime
#  page_url       :string(255)
#  resolved       :boolean          default(FALSE)
#

class Message < ActiveRecord::Base
	belongs_to :user, inverse_of: :messages

	validates :user_id, presence: true, :on => :create
	validates :messagetype, presence: true, :on => :create
	validates :messagecomment, presence: true, :on => :create
end
