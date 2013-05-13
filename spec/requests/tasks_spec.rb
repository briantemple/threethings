require 'spec_helper'

describe "Tasks", :js => true do
  it "begins with no tasks and displays three empty tasks" do
    tasks = Task.all
    tasks.should be_empty
    
    visit root_path
    (1..3).each { |i| page.should have_selector(".todo #new_task_#{i}") }
  end
  
  it "shows incomplete tasks" do
    visit root_path
    
    user = FactoryGirl.create(:user, session_id: session_id)
    task = FactoryGirl.create(:task, status: 0, user_id: user.id)
    
    visit root_path

    page.should have_selector(".todo #checkbox_#{task.id.to_s}")
    page.should have_selector(".todo #text_#{task.id.to_s}")
    find(".todo #text_#{task.id.to_s}").should have_content(task.name)

    page.should_not have_selector(".done #checkbox_#{task.id.to_s}")
    page.should_not have_selector(".done #text_#{task.id.to_s}")
  end
  
  it "shows completed tasks" do
    visit root_path    
    user = FactoryGirl.create(:user, session_id: session_id)
    task = FactoryGirl.create(:task, status: 1, user_id: user.id, completed_at: Time.now)

    visit root_path

    page.should have_selector(".done #checkbox_#{task.id.to_s}")
    page.should have_selector(".done #text_#{task.id.to_s}")
    find(".done #text_#{task.id.to_s}").should have_content(task.name)

    page.should_not have_selector(".todo #checkbox_#{task.id.to_s}")
    page.should_not have_selector(".todo #text_#{task.id.to_s}")
  end

  
  it "adds a task to the user's current tasks" do
    visit root_path
    
    new_task_value = "The new task"
    find(".done").should_not have_content(new_task_value)

    # Randomly pick one, type some text and then hit return
    task_number = rand(3) + 1
  
    find(".todo #new_task_#{task_number}").click()
    page.should have_selector(".todo textarea#new_task_#{task_number}")
    find(".todo textarea#new_task_#{task_number}").native.send_keys("#{new_task_value}")
    find(".todo textarea#new_task_#{task_number}").native.send_keys(:return)
    sleep(1)

    page.should_not have_selector(".todo textarea#new_task_#{task_number}")
    find(".todo div#text_1").should have_content(new_task_value)

    tasks = Task.where({:name => new_task_value})
    tasks.length.should be(1)
    
    task = tasks[0]
    task.should_not be_nil
    task.status.should == 0
    task.name.should eq(new_task_value)
  end
  
  it "does not add a task to the user's current tasks if escape is pressed" do
    visit root_path
    
    new_task_value = "Task that should not be added"
    page.should_not have_selector(".todo div#text_1")

    # Randomly pick one, type some text and then hit return
    task_number = rand(3) + 1
    
    find(".todo #new_task_#{task_number}").click()
    page.should have_selector(".todo textarea#new_task_#{task_number}")
    find(".todo textarea#new_task_#{task_number}").native.send_keys("#{new_task_value}")
    find(".todo textarea#new_task_#{task_number}").native.send_keys(:escape)
    sleep(1)

    page.should_not have_selector(".todo textarea#new_task_#{task_number}")
    page.should_not have_selector(".todo div#text_1")
    
    tasks = Task.all
    tasks.should be_empty
  end
  
  it "completes a user's task" do
    visit root_path
    
    user = FactoryGirl.create(:user, session_id: session_id)
    task = FactoryGirl.create(:task, status: 0, user_id: user.id)
    
    visit root_path

    # Click the checkbox
    find("#checkbox_#{task.id.to_s}").click()

    # Ensure task completed
    page.should have_selector(".done #checkbox_#{task.id.to_s}")
    page.should have_selector(".done #text_#{task.id.to_s}")
    find(".done #text_#{task.id.to_s}").should have_content(task.name)

    page.should_not have_selector(".todo #checkbox_#{task.id.to_s}")
    page.should_not have_selector(".todo #text_#{task.id.to_s}")
    
    updated_task = Task.find(task.id)
    updated_task.should_not be_nil
    updated_task.status.should == 1
  end
  
  it "restarts a user's task" do
    visit root_path
    
    user = FactoryGirl.create(:user, session_id: session_id)
    task = FactoryGirl.create(:task, status: 1, user_id: user.id, completed_at: Time.now)
    visit root_path

    # Click the checkbox
    find("#checkbox_#{task.id.to_s}").click()

    # Ensure task restarted
    page.should have_selector(".todo #checkbox_#{task.id.to_s}")
    page.should have_selector(".todo #text_#{task.id.to_s}")
    find(".todo #text_#{task.id.to_s}").should have_content(task.name)

    page.should_not have_selector(".done #checkbox_#{task.id.to_s}")
    page.should_not have_selector(".done #text_#{task.id.to_s}")
    
    updated_task = Task.find(task.id)
    updated_task.should_not be_nil
    updated_task.status.should == 0
  end
  
  it "edits a user's incomplete task" do
    visit root_path
    
    user = FactoryGirl.create(:user, session_id: session_id)
    task = FactoryGirl.create(:task, status: 0, user_id: user.id)
    
    visit root_path
    
    # Click the task
    find(".todo div#text_#{task.id}").click()
    sleep(1)
    
    # Ensure page has in place editor
    page.should have_selector(".todo textarea#text_#{task.id}")
    editor = find(".todo textarea#text_#{task.id}")
    
    new_task_value = "Updated value"
    editor.native.send_keys(new_task_value)
    editor.native.send_keys(:return)
    sleep(1)

    page.should_not have_selector(".todo textarea#task_#{task.id}")
    find(".todo div#text_#{task.id}").should have_content(new_task_value)

    updated_task = Task.find(task.id)
    updated_task.should_not be_nil
    updated_task.name.should eq(new_task_value)
  end
end
