require 'spec_helper'

module CacheParty
  describe FacebookUserJob do

    describe "#perform", job: true do
      # Skip the callback on create of factory object, because the update_cache method calls
      #   exactly what is being tested here
      #FacebookUser.skip_callback(:create, :after, :update_cache)

      #
      # todo Create FB test pages so not relying on real data (that could change)
      #
      #{bean: 'Food/beverages', joltcafe: 'Restaurant/cafe', jolt_f: 'Clothing'}.each do |trait, category|
      {davetone_basic: 'Dave Tone'}.each do |trait, name|
        it "caches facebook data for #{trait}" do
          fb_user = create(:cache_party_facebook_user, trait.to_sym)
          VCR.use_cassette("facebook/#{trait}") do
            expect(fb_user.name).to be_nil
            FacebookUserJob.new.perform(fb_user.id)
            expect(fb_user.reload.name).to eq(name)
          end
        end # it
      end # Hash
    end # #perform

  end
end


