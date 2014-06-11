module CacheParty
  module Facebook
    module Helpers

      def update_cache_on_create
        Rails.logger.debug { "Processing update_cache_on_create" }
        "#{self.class.name}Job".constantize.new.async.perform(self.id)
      end

      def update_cache_on_persisted
        Rails.logger.debug { "Processing update_cache_on_persisted" }
        FacebookUser.skip_callback(:commit, :after, :update_cache_on_persisted)
        "#{self.class.name}Job".constantize.new.async.perform(self.id)
        FacebookUser.set_callback(:commit, :after, :update_cache_on_persisted)
      end

      def url_for type, opts = {}, &block
        koala = Koala::Facebook::API.new
        begin
          koala.send("get_#{type.to_s}", self.facebook_id, opts, &block)
        rescue Koala::Facebook::ClientError
          Rails.logger.warn("Failed to retrieve asset for #{self.class.name} with id #{self.id}")
          ''
        end
      end


=begin 
# todo Goes to FanClub
    # Put the list of asset files into a var that will survive the destroy process
    after_destroy :list_cache

    # After the record destroy has well and truly been committed to the db, then delete the asset files
    after_commit :clear_cache, on: :destroy
    
#todo move the cache methods to Fan Club; Facebook engine doesn't record the asset path to anything
      # List all locally cached assets associated with this record
      #   and put the list of asset files into a var that will survive the destroy process
      def list_cache
        self.cache_list = []
        if self.respond_to? 'cover_source' and File.file? self.asset_path_for_image('cover')
          self.cache_list << self.asset_path_for_image('cover')
        end
        %w(n s b q).each do |size|
          self.cache_list << self.asset_path_for_image(size) if File.file? self.asset_path_for_image(size)
        end
        self.cache_list
      end

      # After the record destroy has well and truly been committed to the db, then delete the asset files
      # NOTE This method gits hit on *every* commit (destroy AND SAVE)
      def clear_cache
        self.list_cache unless self.cache_list
        self.cache_list.each { |f| FileUtils.rm f if File.file? f }
        self.cache_list = nil
      end
  
      # Delete and download again assets for this record
      def reset_cache; self.clear_cache; self.update_cache; end
=end

    end
  end
end

