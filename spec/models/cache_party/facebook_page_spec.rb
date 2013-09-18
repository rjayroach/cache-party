require 'spec_helper'

module CacheParty
  describe FacebookPage do
  
    subject { build(:cache_party_facebook_page) }
    
    it "has a valid factory" do
      expect(build(:cache_party_facebook_page)).to be_valid
    end

    describe "Validations" do
      %w(url).each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end

      it "fails to create a duplicate url" do
        subject.url = 'test'
        subject.save
        dup = build(:cache_party_facebook_page, url: 'test')
        expect(dup).to_not be_valid
      end
    end  # Validations


    describe "Associations" do
      it "has many facebook page status" do
        expect(subject).to have_many(:facebook_page_stats)
      end
      it "belongs to cacheable" do
        expect(subject).to belong_to(:cacheable)
      end
    end

    describe "#after_commit" do
    end

    describe "#after_save" do
      it "calls update_cache on new record" do
        subject.should_receive(:update_cache)
        subject.save
      end
      it "calls update_cache on save only once" do
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(1)
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(0)
      end
      it "calls update_cache on change of url" do
        subject.save
        subject.url = "something_else"
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(1)
      end
      it "does not call update_cache on change of another field" do
        subject.save
        subject.link = "something_else"
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(0)
      end
    end


    # pass the model id to queue for updating on FB
    describe "#update_cache" do
      it "puts model on the queue to update model and assets" do # focus: true  rspec --tag focus spec/my_spec.rb
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(1)
      end
    end

  end
end


