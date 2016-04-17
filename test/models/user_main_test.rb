# == Schema Information
#
# Table name: user_mains
#
#  id            :integer          not null, primary key
#  user_id       :string
#  user_type     :string(1)
#  user_email    :string(50)
#  user_password :string(20)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class UserMainTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
