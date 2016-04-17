require 'rails_helper'
require 'factory_girl'

RSpec.describe "UserSignups", type: :request do

  subject { page }

  describe "GET /users/new" do
    before { visit new_user_path }
    it { should have_selector('h1', :text => "Sign Up") }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    # it { should have_selector('h1',    :text => user.name) }
    it { should have_selector('title', :text => user.name, :visible => false) }
  end

  describe "create new user by signup" do
    before { visit new_user_path }
    let(:submit) { "Register" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Enter your user ID:",          with: "bing5tui3"
        fill_in "Enter your email:",            with: "naychmod@icloud.com"
        fill_in "Enter your new password:",     with: "123456"
        fill_in "Reenter your password:",       with: "123456"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
  
  # 编辑个人信息测试
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('p',     :text => "Edit Your Profile") }
      it { should have_selector('title', :text => "Edit", :visible => false) }
    end

    # describe "with invalid information" do
    #   before { click_button "Save" }
    #   it { should have_content('error') }
    # end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Your User Name",        with: new_name
        fill_in "Your Email",            with: new_email
        fill_in "Your New Password",     with: user.password
        fill_in "Password Confirmation", with: user.password
        click_button "Save"
      end

      it { should have_selector('title', :text => new_name, :visible => false) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Log out', :href => login_path) }
      specify { user.reload.name.should  == new_name  }
      specify { user.reload.email.should == new_email }
    end
  end

  # 测试所有用户的列表
  describe "index" do
    before do 
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, :name => "bing5tui5", :email => "bing5tui5@bankcomm.com")
      FactoryGirl.create(:user, :name => "bing5tui6", :email => "bing5tui6@bankcomm.com")
      visit users_path
    end

    it { should have_selector('title', :text => 'Members', :visible => false) }
    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', :text => user.name)
      end
    end
  end
end
