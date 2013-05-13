def session_id
  Capybara.current_session.driver.browser.manage.all_cookies.each do |cookie|
    if cookie[:name] == "remember_me"
      return cookie[:value]
    end
  end
  
  nil
end