# lib/cache_party/facebook/helpers.rb

module CacheParty
  module Facebook
    module Helpers

      # 
      # Update local cache with data from Facebook
      # Place a reqeust on the queue to update this object with data from Facebook
      #
      #def update_cache; Rails.logger.warn { "updating cache" }; "#{self.class.name}Job".constantize.new.async.perform(self.id); end
      #def update_cache; "#{self.class.name}Job".constantize.new.perform(self.id); end
  
    def update_cache_on_create
      Rails.logger.warn { "updating cache" }
      "#{self.class.name}Job".constantize.new.async.perform(self.id)
      Rails.logger.warn { "after updating cache" }
    end


    # 
    # Update the cache record on any type of update to it
    #   which means that the after_commit callback needs to be disabled
    #   or there will be an infinite recurssion generated
    #
    def update_cache_on_persisted
      FacebookUser.skip_callback(:commit, :after, :update_cache_on_persisted)
      "#{self.class.name}Job".constantize.new.async.perform(self.id)
      FacebookUser.set_callback(:commit, :after, :update_cache_on_persisted)
    end


  
      #
      # List all locally cached assets associated with this record
      #   and put the list of asset files into a var that will survive the destroy process
      #
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


      #
      # After the record destroy has well and truly been committed to the db, then delete the asset files
      # NOTE This method gits hit on *every* commit (destroy AND SAVE)
      #
      def clear_cache
        self.list_cache unless self.cache_list
        self.cache_list.each { |f| FileUtils.rm f if File.file? f }
        self.cache_list = nil
      end
  

      # 
      # Delete and download again assets for this record
      #
      def reset_cache; self.clear_cache; self.update_cache; end


      # 
      # Given parameter of picture size, 'cover' or nil, return the full path to image on FS
      #
      def asset_path_for_image size=nil; "#{APPLICATION_CONFIG['asset_path']}/#{self.image_base_name(size)}" end
  
  
      #
      # Given parameter of picture size, 'cover' or nil, return the path relative to /public to image on FS
      #
      def view_path_for_image size=nil; "#{APPLICATION_CONFIG['view_path']}/#{self.image_base_name(size)}" end
  
  
      #
      # Given parameter of picture size, 'cover' or nil, return the base name of the image file
      #
      def image_base_name size=nil
        name = self.image size
        name = name.split('/').pop if name.index('/')
        name
      end
  
  
      #
      # If no size is requested and the picture exists, set return to the picture
      # If the size requested is 'cover' set return to the cover_source
      # If the size requested is one of 'n s b q' then set return to the picture adjusted for size
      # If the size is any other value, set the return to that value
      # If the return value is still nil then return ''
      #
      def image size=nil
        if size.nil?
          pic = self.picture
        elsif size.eql?('cover')
          pic = self.respond_to?('cover_source') ? self.cover_source : nil
        elsif 'n s b q'.include? size
          pic = self.picture_for_size(size)
        else
          pic = size
        end
        pic.nil? ? '' : pic
      end
  

      # 
      # Return the full contents of the field adjusted only for size
      #
      def picture_for_size size
        name = self.picture
        return nil if name.nil?
        url = ''
        if name.index('/')
          ubi = name.split('/')
          name = ubi.pop
          url = ubi.join('/') + '/'
        end
  
        base_name, extension = name.split('.')
        real_base = base_name.rindex('_') ? "#{base_name[0...base_name.rindex('_')]}_#{size}" : base_name
        ab = "#{url}#{real_base}.#{extension}"
        #Rails.logger.warn "ab   #{ab}"
        #Rails.logger.warn "orig #{url}#{base_name[0...base_name.rindex('_')]}_#{size}.#{extension}"
        ab
        #"#{url}#{base_name[0...base_name.rindex('_')]}_#{size}.#{extension}"
      end


      # 
      # Queue a URL to be downloaded and saved to local File System
      #
      def retrieve_asset(url = nil)
        return if ( url.nil? or not download?(url) )
        file = self.asset_path_for_image(url)
        Rails.logger.info "Retrieve Facebook asset from: #{url}  Save to: #{file}"
        open(file, 'wb') do |file|
          file << open(url).read
        end
      end

  
      # 
      # Return true if the url is valid _and_ the asset is not found on the file system
      #
      def download?(url)
        return false if not self.uri?(url)
        not File.exists?(self.asset_path_for_image(url))
      end
      
  
      # 
      # Is the string passed in a valid URI?
      #
      def uri?(string)
        uri = URI.parse(string)
        %w( http https ).include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

    end
  end
end

