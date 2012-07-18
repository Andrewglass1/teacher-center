module UserSupport
  module Login
    def login(user)
      fill_in "user[email]", :with => user.email
      fill_in "user[password]", :with => 'hungry'
      within("form") do
        click_link_or_button 'Sign in'
      end
    end
  end
  module Logout
    def logout()
      click_on "Sign out"
    end
  end
  module Signup
    def signup(user)
      fill_in "user[email]", :with => user.email
      fill_in "user[password]", :with => 'hungry'
      fill_in "user[password_confirmation]", :with => 'hungry'
      within("form") do
        click_link_or_button 'Sign up'
      end
    end
  end
end
