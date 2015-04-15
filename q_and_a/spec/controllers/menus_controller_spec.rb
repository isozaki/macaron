require 'rails_helper'

RSpec.describe MenusController, :type => :controller do
  before(:each) do
    @logined_user = logined_by(mock_logined_user)
  end
end
