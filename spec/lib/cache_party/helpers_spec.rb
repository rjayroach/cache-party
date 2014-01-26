require 'spec_helper'

module CacheParty
  module Facebook
    describe 'Helpers' do
      before(:each) do
        @subject = create(:cache_party_facebook_page, :joltcafe)
      end
      

      describe 'application.yml settings' do
        # 
        # Return the directory where assets are saved locally
        #
        it "returns the default view path" do
          expect(APPLICATION_CONFIG['view_path']).to eq('/test/cache/facebook')
        end
  
        # 
        # Return the path to assets relative to /pubic
        #
        it "returns the default asset path" do
          expect(APPLICATION_CONFIG['asset_path']).to eq("#{Rails.root}/public/test/cache/facebook")
        end
      end


      describe "#image" do
        it "with no size param, it returns the picture" do
          expect(@subject.image).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_q.jpg")
        end
        it "returns the cover_source if the size requested is 'cover'" do
          expect(@subject.image('cover')).to eq("http://sphotos-f.ak.fbcdn.net/hphotos-ak-prn1/s720x720/562219_378872905484694_26367699_n.jpg")
        end
        it "returns the size requested is one of 'n s b q' then set return to the picture adjusted for size" do
          expect(@subject.image('n')).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_n.jpg")
          expect(@subject.image('s')).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_s.jpg")
          expect(@subject.image('b')).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_b.jpg")
          expect(@subject.image('q')).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_q.jpg")
        end
      end

      describe "#picture_for_size" do
        it "returns the size requested is one of 'n s b q' then set return to the picture adjusted for size" do
          expect(@subject.picture_for_size('n')).to eq("http://profile.ak.fbcdn.net/hprofile-ak-ash3/41578_138956892809631_7376_n.jpg")
        end
      end
        #cover_source "http://sphotos-f.ak.fbcdn.net/hphotos-ak-prn1/s720x720/562219_378872905484694_26367699_n.jpg"

      describe "#image_base_name" do
        it "asset path for image" do
          expect(@subject.image_base_name).to eq("41578_138956892809631_7376_q.jpg")
        end
        it "returns the size requested is one of 'n s b q' then set return to the picture adjusted for size" do
          expect(@subject.image_base_name('n')).to eq("41578_138956892809631_7376_n.jpg")
          expect(@subject.image_base_name('s')).to eq("41578_138956892809631_7376_s.jpg")
          expect(@subject.image_base_name('b')).to eq("41578_138956892809631_7376_b.jpg")
          expect(@subject.image_base_name('q')).to eq("41578_138956892809631_7376_q.jpg")
        end
        it "returns the cover_source if the size requested is 'cover'" do
          expect(@subject.image_base_name('cover')).to eq("562219_378872905484694_26367699_n.jpg")
        end
      end

      describe "#view_path_for_image" do
        it "asset path for image" do
          expect(@subject.view_path_for_image).to eq("#{APPLICATION_CONFIG['view_path']}/41578_138956892809631_7376_q.jpg")
        end
        it "returns the size requested is one of 'n s b q' then set return to the picture adjusted for size" do
          expect(@subject.view_path_for_image('n')).to eq("#{APPLICATION_CONFIG['view_path']}/41578_138956892809631_7376_n.jpg")
          expect(@subject.view_path_for_image('s')).to eq("#{APPLICATION_CONFIG['view_path']}/41578_138956892809631_7376_s.jpg")
          expect(@subject.view_path_for_image('b')).to eq("#{APPLICATION_CONFIG['view_path']}/41578_138956892809631_7376_b.jpg")
          expect(@subject.view_path_for_image('q')).to eq("#{APPLICATION_CONFIG['view_path']}/41578_138956892809631_7376_q.jpg")
        end
        it "returns the cover_source if the size requested is 'cover'" do
         expect(@subject.view_path_for_image('cover')).to eq("#{APPLICATION_CONFIG['view_path']}/562219_378872905484694_26367699_n.jpg")
        end
      end

      describe "#asset_path_for_image" do
        it "asset path for image" do
          expect(@subject.asset_path_for_image).to eq("#{APPLICATION_CONFIG['asset_path']}/41578_138956892809631_7376_q.jpg")
        end
        it "returns the size requested is one of 'n s b q' then set return to the picture adjusted for size" do
          expect(@subject.asset_path_for_image('n')).to eq("#{APPLICATION_CONFIG['asset_path']}/41578_138956892809631_7376_n.jpg")
          expect(@subject.asset_path_for_image('s')).to eq("#{APPLICATION_CONFIG['asset_path']}/41578_138956892809631_7376_s.jpg")
          expect(@subject.asset_path_for_image('b')).to eq("#{APPLICATION_CONFIG['asset_path']}/41578_138956892809631_7376_b.jpg")
          expect(@subject.asset_path_for_image('q')).to eq("#{APPLICATION_CONFIG['asset_path']}/41578_138956892809631_7376_q.jpg")
        end
        it "returns the cover_source if the size requested is 'cover'" do
         expect(@subject.asset_path_for_image('cover')).to eq("#{APPLICATION_CONFIG['asset_path']}/562219_378872905484694_26367699_n.jpg")
        end
      end

    end
  end
end

