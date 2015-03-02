# == Schema Information
#
# Table name: answer_attachments
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  filename   :string(255)      not null
#  filesize   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe AnswerAttachment, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
