require 'spec_helper'

=begin
      # NOTE: If we run the commit callbacks (:update_cache) then:
      # 1) run the test with job: true
      it "fails to create a duplicate username", job: true do
        # 2) run the commit, etc. inside a VCR block
        # and 3) run_callbacks(:commit) must be called manually to trigger the callback
        VCR.use_cassette("facebook/davetone_basic") do
          subject.save
          subject.run_callbacks(:commit)
        end
      end
      # NOTE: otherwise the commit callback(s) won't be run
=end

module CacheParty
  describe FacebookUser do

    subject { build(:cache_party_facebook_user) }

    it "has a valid factory" do
      expect(subject).to be_valid
    end


    describe "Validations" do
      # NOTE the test for user should be removed when the model is fully decoupled from DryAuth
      #%w().each do |attr|
      %w(user).each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end

      it "fails to create a duplicate username" do
        subject.save
        dup = build(:cache_party_facebook_user) #, :davetone_basic)
        expect(dup).to_not be_valid
      end

    end  # Validations


    describe "Associations" do
      it "belongs to User" do
        expect(subject).to belong_to(:user)
      end
      it "belongs to cacheable" do
        expect(subject).to belong_to(:cacheable)
      end
    end


    describe "#update_cache_on_create" do 

      describe "on create" do #, skip: true do
        it "is called once" do
          subject.should_receive(:update_cache_on_create).once
          subject.save
          subject.run_callbacks(:commit)
        end
        it "updates the record from FB", job: true do
          VCR.use_cassette("facebook/davetone_basic") do
            expect(subject.locale).to be_nil
            subject.save
            subject.run_callbacks(:commit)
            expect(subject.reload.locale).to eq('en_US')
          end
        end
      end

      describe "on update" do #, skip: true do
        it "is called once" do
          subject.should_receive(:update_cache_on_create).twice
          subject.save
          subject.run_callbacks(:commit)
          subject.reload.update_attributes(locale: nil)
          subject.run_callbacks(:commit)
        end
        it "does NOT update the record from FB", job: true do
          VCR.use_cassette("facebook/davetone_basic") do
            subject.save
            subject.run_callbacks(:commit)
            subject.reload.update_attributes(locale: nil)
            expect(subject.locale).to be_nil
            subject.run_callbacks(:commit)
            expect(subject.reload.locale).to be_nil
          end
        end
      end
    end

  end
end


