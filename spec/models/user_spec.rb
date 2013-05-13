require 'spec_helper'

describe "User" do
  it "can migrate a (session) user's data" do
    session_user = FactoryGirl.create(:user)
    session_task = FactoryGirl.create(:task, status: 0, user_id: session_user.id)
    
    authenticated_user = FactoryGirl.create(:user)
    authenticated_user_task = FactoryGirl.create(:task, status: 0, user_id: authenticated_user.id)
    authenticated_user.migrate_user(session_user)
    
    updated_task = Task.find(session_task.id)
    updated_task.should_not be_nil
    updated_task.user_id.should == authenticated_user.id
    
    Task.where({:user_id => authenticated_user.id}).length.should == 2
    
    expect{User.find(session_user.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end