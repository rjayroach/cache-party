# Read about factories at https://github.com/thoughtbot/factory_girl

module CacheParty
  FactoryGirl.define do
    factory :cache_party_facebook_page, class: FacebookPage do
      url "joltcafe"
      #joltcafe
      #picture nil
      #  picture "http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_q.jpg"

      trait :joltcafe do
        facebook_id "138956892809631"
        name "Jolt Cafe"
        url "joltcafe"
        link "http://www.facebook.com/joltcafe"
        category "Restaurant/cafe"
        phone nil
        cover_source "http://sphotos-f.ak.fbcdn.net/hphotos-ak-prn1/s720x720/562219_378872905484694_26367699_n.jpg"
        picture "http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_q.jpg"
      end # trait :joltcafe

    end
  end
end


