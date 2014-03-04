require 'spec_helper'

module CacheParty
  describe FacebookUserJob do

    describe "#perform", job: true do
      {davetone_basic: 'Dave Tone'}.each do |trait, name|
        it "caches facebook data for #{trait}" do
          fb_user = create(:cache_party_facebook_user) #, trait.to_sym)
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


