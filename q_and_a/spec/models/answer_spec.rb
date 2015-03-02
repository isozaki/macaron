# == Schema Information
#
# Table name: answers
#
#  id                :integer          not null, primary key
#  question_id       :integer          not null
#  answer            :text             not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(64)       not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

RSpec.describe Answer, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
