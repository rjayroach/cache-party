require 'spec_helper'

module CacheParty
  describe FacebookPage do
  
    subject { build(:cache_party_facebook_page) }
=begin
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

      it "fails to create a duplicate url", job: true do
        subject.update_attributes(url: 'test')
        dup = build(:cache_party_facebook_page, url: 'test')
        expect(dup).to_not be_valid
      end
    end  # Validations


    describe "Associations" do
      it "has many facebook page status" do
        expect(subject).to have_many(:stats)
      end
      it "belongs to cacheable" do
        expect(subject).to belong_to(:cacheable)
      end
    end
=end


    # 
    # NOTE All the calls to update cache are stubbed out so there is no need to call vcr
    # NOTE The after_commit callback doesn't run normally under Rspec
    #
    describe "#update_cache_on_create" do 
        it "is called once" do
          subject.should_receive(:update_cache_on_create).once
          subject.save
          subject.run_callbacks(:commit)
        end
        it "updates the record from FB", job: true do
          VCR.use_cassette("facebook/joltcafe") do
            expect(subject.name).to be_nil
            subject.save
            subject.run_callbacks(:commit)
            expect(subject.reload.name).to eq('Jolt Cafe')
          end
        end
      end

    describe "#after_save", skip: true do
      it "calls update_cache on new record", job: true do
        subject.should_receive(:update_cache).once
        subject.save
        subject.run_callbacks(:commit)
        expect(subject.url_updated?).to be_true
      end
      it "calls update_cache on save only once", job: true do
        subject.should_receive(:update_cache).once
        subject.save
        subject.run_callbacks(:commit)
        subject.save
        subject.run_callbacks(:commit)
      end
      it "calls update_cache on change of url", job: true do
        subject.should_receive(:update_cache).twice
        subject.save
        subject.run_callbacks(:commit)
        # It seems like update_attributes does cause the commit callback to run in rspec
        subject.update_attributes(url: "something_else")
      end
      it "does not call update_cache on change of another field", job: true do
        subject.should_receive(:update_cache).once
        subject.save
        subject.run_callbacks(:commit)
        subject.update_attributes(link: "something_else")
        subject.run_callbacks(:commit)
      end
    end

=begin
    # pass the model id to queue for updating on FB
    describe "#update_cache" do
      it "puts model on the queue to update model and assets" do # focus: true  rspec --tag focus spec/my_spec.rb
        expect{ subject.save }.to change{ SuckerPunch::Queue.new(:FacebookPage).jobs.size }.by(1)
      end
    end
=end

  end
end


