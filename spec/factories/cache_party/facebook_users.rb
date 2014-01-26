=begin
The FacebookUser is totally dependent upon McpAuth for the facebook_id
While this is DRY, it is highly coupled, resulting in the following drawbacks:
- cannot be tested in isolation of the Auth gem
- an FB user can never be cached without a user record also being created...
- just bogus...
- the facebook id is -the single- identifying link to FB so if it's not here then not real useful
=end
module CacheParty
  FactoryGirl.define do
    factory :cache_party_facebook_user, class: FacebookUser do
      username "dave.tone.31"
      association :user, factory: :mcp_auth_user
      #davetone
      #picture nil

      trait :davetone_basic do
        facebook_id "100005787840155"
        #username "dave.tone.31"
      end


      trait :davetone do
        facebook_id "100005787840155"
        name "Dave Tone"
        first_name "Dave"
        middle_name nil
        last_name "Tone"
        gender "male"
        locale "en_US"
        link "http://www.facebook.com/dave.tone.31"
        username "dave.tone.31"
        email nil
        picture "http://profile.ak.fbcdn.net/hprofile-ak-prn1/174153_100005787840155_2101067759_q.jpg"
        verified nil
        updated_time nil
      end # davetone

    end
  end
end

