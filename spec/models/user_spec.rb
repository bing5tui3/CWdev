# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  admin_type            :string
#  email                 :string
#  password_digest       :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  icode                 :string
#  remember_token        :string
#  portrait_file_name    :string
#  portrait_content_type :string
#  portrait_file_size    :integer
#  portrait_updated_at   :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  
  before { @user = User.new(name:                  "bing5tui3", 
                            admin_type:            "1",
                            email:                 "naychmod@icloud.com",
                            password:              "123456",
                            password_confirmation: "123456"
                            )  
         }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) } 
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should be_valid }
  it { should respond_to(:articles) }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "name should be 50 maximum" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "email should have right format" do
    it { should be_valid }
  end

  describe "email is not valid if it is 'naychmod'" do
    before { @user.email = "naychmod" }
    it { should_not be_valid }
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_falsey }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 6 }
    it { should_not be_invalid }
  end

  describe "articles associations" do
    before { @user.save }
    let!(:older_article) do
      FactoryGirl.create(:article, :user => @user, :created_at => 1.day.ago)
    end

    let!(:newer_article) do
      FactoryGirl.create(:article, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have the right articles in the right order" do
      @user.articles.should == [newer_article, older_article]
    end

    it "should destroy associtated articles" do
      articles = @user.articles
      @user.destroy
      articles.each do |article|
        Article.find_by_id(article.id).should be_nil
      end
    end
  end

end
