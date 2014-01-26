require 'spec_helper'

module CacheParty
  describe FacebookPageJob do

    describe "#perform", job: true do
      # Skip the callback on create of factory object, because the update_cache method calls
      #   exactly what is being tested here
      FacebookPage.skip_callback(:save, :after, :update_cache)

      #
      # todo Create FB test pages so not relying on real data (that could change)
      #
      {bean: 'Food/beverages', joltcafe: 'Restaurant/cafe', jolt_f: 'Clothing'}.each do |trait, category|
        it "caches facebook data for #{trait}" do
          fb_page = create(:cache_party_facebook_page, trait.to_sym)
          VCR.use_cassette("facebook/#{trait}") do
            expect(fb_page.category).to be_nil
            FacebookPageJob.new.perform(fb_page.id)
            expect(fb_page.reload.category).to eq(category)
          end
        end # it
      end # Hash
    end # #perform

  end
end


=begin
    # Tag the spec as a job spec so data is persisted long enough for the test
    #describe EmailJob, job: true do
      #let(:user) { FactoryGirl.create(:user) }
          #expect {
          #  FacebookPageJob.new.perform(subject.id)
          #}.to change{ ActionMailer::Base.deliveries.size }.by(1)
=end

