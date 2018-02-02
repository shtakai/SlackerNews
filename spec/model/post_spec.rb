require "rails_helper"

# # spec/models/user_spec.rb
#
# # Prefix class methods with a '.'
# describe User, '.active' do
#   it 'returns only active users' do
#     # setup
#     active_user = create(:user, active: true)
#     non_active_user = create(:user, active: false)
#
#     # exercise
#     result = User.active
#
#     # verify
#     expect(result).to eq [active_user]
#
#     # teardown is handled for you by RSpec
#   end
# end
#
# # Prefix instance methods with a '#'
# describe User, '#name' do
#   it 'returns the concatenated first and last name' do
#     # setup
#     user = build(:user, first_name: 'Josh', last_name: 'Steiner')
#
#     # excercise and verify
#     expect(user.name).to eq 'Josh Steiner'
#   end
#end

describe Post do

  it 'model has a valid factory' do
    create(:post)
  end

  it 'has a sane looking heat generated after creation' do
    post = create(:post)
    expect(post.heat.to_i).to be > 1000
  end

  it 'only saves when a URL is given' do
    crap_post = build(:post, url: '')
    expect {crap_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    crap_post.url = 'http/wurst.de'
    expect {crap_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  # it 'validates that the url is unique' do
  #   wurst_url =  'http://wurst.de'
  #   post1 = create(:post, url: wurst_url)
  #   post2 = create(:post, url: wurst_url)
  # end
end