# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(64)       not null
#  name_kane  :string(64)       not null
#  login      :string(255)      not null
#  password   :string(16)       not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
