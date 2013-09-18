require 'spec_helper'

module CacheParty
  describe FacebookUser do

    subject { build(:cache_party_facebook_user) }
    
    it "has a valid factory" do
      expect(build(:cache_party_facebook_user)).to be_valid
    end

    describe "Validations" do
      %w(user).each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end

      it "fails to create a duplicate username" do
        subject.username = 'test'
        subject.save
        dup = build(:cache_party_facebook_user, username: 'test')
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

    describe "#after_create" do
      it "calls update_cache on new record" do
        subject.should_receive(:update_cache)
        subject.save
      end
      it "calls update_cache on save only once" do
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookUser).jobs.size }.by(1)
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookUser).jobs.size }.by(0)
      end
      it "does not call update_cache on change of another field" do
        subject.save
        subject.link = "something_else"
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookUser).jobs.size }.by(0)
      end
    end

  end
end


