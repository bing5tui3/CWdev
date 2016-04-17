require 'rails_helper'
require 'rspec/its'

RSpec.describe Article, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  # before do 
  #   @article = Article.new(:title  => 'First Article',
  #                          :content => 'Test String',
  #                          :user_id => user.id )
  # end

  before do
    @article = user.articles.build(:title => 'First Article',
                                   :content => 'Test String' )
  end

  subject{ @article }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }
  its(:user) { should == user }

  describe "when user_id is not present" do
    before { @article.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do 
    before { @article.content = " " }
    it { should_not be_valid }
  end
end
