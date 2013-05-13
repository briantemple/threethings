require 'spec_helper'

describe "Routes", :js => true do
  it "can render the root page" do
    visit root_path
    page.should_not have_content("Loading")
  end
  
  it "can navigate to the about page" do
    visit root_path
    click_on("About")
    page.should_not have_content("Loading")
  end
end