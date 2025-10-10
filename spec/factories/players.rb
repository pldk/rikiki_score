# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :player do
    name { 'MyString' }
    description { 'MyString' }
    rank { 1 }
  end
end
