# == Schema Information
#
# Table name: contestants
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  show_id        :integer
#  age            :integer
#  gender         :string(255)
#  occupation     :string(255)
#  description    :text
#  status_on_show :string(255)
#  present        :boolean          default(TRUE)
#

class Contestant < ActiveRecord::Base
	belongs_to :show
	has_and_belongs_to_many :rosters
end
