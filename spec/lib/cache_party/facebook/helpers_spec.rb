require 'spec_helper'

module CacheParty
  module Facebook
    describe 'Helpers' do

      describe "#update_cache_on_create" do
        it "calls the job for FacebookPage" do
          subject = build(:cache_party_facebook_page, :joltcafe)
          FacebookPageJob.any_instance.stub(:perform).and_return(true)
          expect_any_instance_of(FacebookPageJob).to receive(:perform)
          subject.update_cache_on_create
        end
        it "calls the job for FacebookUser" do
          subject = build(:cache_party_facebook_user)
          FacebookUserJob.any_instance.stub(:perform).and_return(true)
          expect_any_instance_of(FacebookUserJob).to receive(:perform)
          subject.update_cache_on_create
        end
      end

      describe "#update_cache_on_persisted" do
        it "calls the job for FacebookPage" do
          subject = build(:cache_party_facebook_page, :joltcafe)
          FacebookPageJob.any_instance.stub(:perform).and_return(true)
          expect_any_instance_of(FacebookPageJob).to receive(:perform)
          subject.update_cache_on_persisted
        end
        it "calls the job for FacebookUser" do
          subject = build(:cache_party_facebook_user)
          FacebookUserJob.any_instance.stub(:perform).and_return(true)
          expect_any_instance_of(FacebookUserJob).to receive(:perform)
          subject.update_cache_on_persisted
        end
      end

      describe "#url_for", job: true do
        it 'returns the picture of a Facebook Page' do
          subject = build(:cache_party_facebook_page, :joltcafe)
          VCR.use_cassette("facebook/joltcafe") do
            expect(File.basename(URI.parse(subject.url_for :picture).path)).to eq '41578_138956892809631_7376_q.jpg'
          end
        end

        it 'returns the picture of a Facebook User' do
          subject = build(:cache_party_facebook_user)
          VCR.use_cassette("facebook/davetone_basic") do
            expect(File.basename(URI.parse(subject.url_for :picture).path)).to eq '174153_100005787840155_2101067759_t.jpg'
          end
        end

        it "returns the url to picture 160x160", job: true do
          subject = build(:cache_party_facebook_user)
          VCR.use_cassette("facebook/davetone_basic") do
            expect(File.basename(URI.parse(subject.url_for(:picture, {width: '160', height: '160'}).path))).to eq(
              '944425_115706918632236_180693481_n.jpg'
            )
          end
        end
      end
      
    end
  end
end

