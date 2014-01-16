require 'fog'

module RedmineFog
  module AttachmentPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        # attr_accessor :s3_access_key_id, :s3_secret_acces_key, :s3_bucket, :s3_bucket
        after_validation :move_to_fog_storage
        before_destroy   :delete_from_fog_storage
      end
    end

    module InstanceMethods
    
      @@connection = nil
      
      def move_to_fog_storage
        if @temp_file
          self.disk_filename = Attachment.disk_filename(filename) if disk_filename.blank?
          content = @temp_file.respond_to?(:read) ? @temp_file.read : @temp_file
          # TODO: actually store the file
          md5 = Digest::MD5.new
          self.digest = md5.hexdigest
        end
        # set this to nil so that files_to_final_location
        # fails to run in the Attachment class
        @temp_file = nil
      end
      
      def delete_from_fog_storage
        # TODO: delete from fog storage
      end
    end
  end
end