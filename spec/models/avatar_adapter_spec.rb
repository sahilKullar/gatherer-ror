require "rails_helper"

describe AvatarAdapter do
  it "accurately receives image url", :vcr do
    user = instance_double(User, twitter_handle: "salkullar")
    adapter = AvatarAdapter.new(user)
    url = "http://pbs.twimg.com/profile_images/1371552537153781764/77cdD1px_bigger.jpg"
    expect(adapter.image_url).to eq(url)
  end
end
