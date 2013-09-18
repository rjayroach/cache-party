# Read about factories at https://github.com/thoughtbot/factory_girl

module CacheParty
  FactoryGirl.define do
    factory :cache_party_facebook_post, class: FacebookPost do
      contentable nil
      association :postable, factory: :cache_party_facebook_user
      association :authorizable, factory: [:mcp_auth_auth_profile, :dave_tone_facebook]
      #association :authorizable, factory: [:cache_party_facebook_application, :maximum_cole]
      #now
  
      trait :now do
        attempted_at { Time.now }
        posted true
      end

      trait :today do
        attempted_at { Time.at((0.day.ago.end_of_day.to_f - 0.day.ago.beginning_of_day.to_f) * rand +
                           0.day.ago.beginning_of_day.to_f) }
        created_at {attempted_at}
        posted true
      end # today
  
      trait :yesterday do
        attempted_at { Time.at((1.day.ago.end_of_day.to_f - 1.day.ago.beginning_of_day.to_f) * rand +
                           1.day.ago.beginning_of_day.to_f) }
        created_at {attempted_at}
        posted true
      end # yesterday
  
    end
  end
end

