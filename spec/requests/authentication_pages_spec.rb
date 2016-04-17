require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  subject { page }

  # 登录测试：
  # 访问登录页面login_path: /login (get)
  # 返回的页面应有h2 => Log in  title => Log in
  describe "login page" do
    before { visit login_path }

    it { should have_selector('h2',    :text => 'Log in') }
    it { should have_selector('title', :text => 'Log in', :visible => false) }
  end

  # describe "login" do
  #   before do 
  #     visit login_path
  #     click_button "Log in" 
  #   end

  #   it { should have_selector('div.alert.alert-danger', :text => "Invalid") }
  # end

  # ====================================================================================
  # FactoryGirl先创建一个wangr_61的用户(spec/factories.rb)
  # 保存user
  # 访问登录页面，填写user的email和password 点击Log in按钮
  describe "with valid information" do 
    let(:user) { FactoryGirl.create(:user) }
    before do 
      user.save
      # visit login_path
      # fill_in "Email",  with: user.email
      # fill_in "Password", with: user.password
      # click_button "Log in"
      sign_in user
    end
    # 没法识别spec/support/utilities.rb中的sign_in方法
    # before { sign_in user }

    # 返回页面中title应该为wangr_61
    it { should have_selector('title', :text => user.name, :visible => false ) }
    # 返回页面中应该有wangr_61的链接（尚未添加）
    # it { should have_link(user.name, :href => user_path(user)) }
    # 登录成功后应有Log out链接
    it { should have_link('Log out', :href => login_path) }
    # 登录成功后不应该有Log in链接
    it { should_not have_link('Log in', :href => login_path) }
    # 登录成功后应该有Profile链接
    it { should have_link('Profile', :href => user_path(user)) }
    # 登录成功后应该有Change链接
    it { should have_link('Change', :href => edit_user_path(user)) }
  end

  
  describe "authorization" do
    # 用没有sign in的用户去编辑个人信息 应该会被引导至login界面
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', :text => "Log in", :visible => false) }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end

    # 
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, 
                                            :email => "test@exmaple.com",
                                            :name  => "wronguser"
                                            ) }

      before { sign_in user }

      describe "visiting Users#Edit page" do
        before { visit edit_user_path(wrong_user) } 
        it { should_not have_selector('title', :text => "Edit", :visible => false) }
      end

      describe "submitting a PUT request to the Users#Update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    # 如果使用没有登录的用户直接visit编辑页面则会跳转至登录页面，并执行登录
    # 登录后应该跳转至编辑页面
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        describe "after logged in" do
          it "should render the desired protected page" do
            page.should have_selector('title', :text => "Edit", :visible => false)
          end
        end
      end

      describe "in the Users controller" do
        describe { visit users_path }
        it { should have_selector('title', :text => "Log in", :visible => false)}
      end

    end
  end

end
