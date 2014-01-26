require 'spec_helper'

module CacheParty
  describe FacebookPost do

    subject { create(:cache_party_facebook_post) }
    
    it "has a valid factory" do
      expect(create(:cache_party_facebook_post)).to be_valid
    end

    # TODO add postable and authorizable
    describe "Validations" do
      #%w(contentable_id contentable_type postable_id postable_type authorizable_id authorizable_type).each do |attr|
      %w().each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end
    end  # Validations


    describe "Associations" do
      it "belongs to a contentable object" do
        expect(subject).to belong_to(:contentable)
      end
      it "belongs to a postable object" do
        expect(subject).to belong_to(:postable)
      end
      it "belongs to an authorizable object" do
        expect(subject).to belong_to(:authorizable)
      end
    end


    describe "scopes" do
    end

    describe "#post" do
      it "posts the content to a Facebook Object" do
        SuckerPunch::Queue.any_instance.stub(:perform).and_return(true)
        #SuckerPunch::Queue.stub(:new).with('')
        subject.post
        expect( SuckerPunch::Queue.any_instance).to have_received(:new).once
        #expect(invitation).to have_received(:accept).twice
        #expect{ subject.post }.to change{ SuckerPunch::Queue.new(:FacebookPost).jobs.size }.by(1)
      end
        #auth_provider = create(:mcp_auth_auth_profile, :dave_tone_facebook)
        #post_for = create(:cache_party_facebook_user)
        #subject.authorizable = auth_provider
        #subject.postable = post_for
        #subject.content = "hello world!"
        #subject.post
    end


  end
end

