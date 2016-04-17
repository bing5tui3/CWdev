FactoryGirl.define do  factory :article_category_relationship do
    
  end
  factory :user_category_relationship do
    
  end
  factory :category do
    
  end
  
  
  factory :article do
    title   "MyString"
    content "MyText"
    user_id 1
  end

  # factory :user do
  #   name                  "bing5jin3"
  #   admin_type            "1"
  #   email                 "wangr_61@bankcomm.com"
  #   password              "123456"
  #   password_confirmation "123456"
  # end

  factory :user, class: User do
    name                  "wangr_61"
    admin_type            "2"
    email                 "wangr_61@bankcomm.com"
    password              "wemadefox"
    password_confirmation "wemadefox"
  end
end