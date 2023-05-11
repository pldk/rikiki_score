# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
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
