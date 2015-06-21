# == Schema Information
#
# Table name: matter_users
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  matter_id  :integer          not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class MatterUser < ActiveRecord::Base
  validates(:user_id, presence: true)
  validates(:matter_id, presence: true)

  belongs_to(:user)
  belongs_to(:matter)
end
