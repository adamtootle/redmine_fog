require 'fog'

module RedmineFog
  module AttachmentPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        after_validation :move_to_fog_storage
        before_destroy   :delete_from_fog_storage
      end
    end

    module InstanceMethods
      
      def move_to_fog_storage
        if @temp_file
          self.disk_filename = Attachment.disk_filename(filename) if disk_filename.blank?
          content = @temp_file.respond_to?(:read) ? @temp_file.read : @temp_file
          
          if @temp_file.respond_to?(:content_type)
            self.content_type = @temp_file.content_type.to_s.chomp
          end
          if content_type.blank? && filename.present?
            self.content_type = Redmine::MimeType.of(filename)
          end
          
          RedmineFog::Storage.move_to_fog_storage(self.disk_filename, content, self.content_type)
          md5 = Digest::MD5.new
          self.digest = md5.hexdigest
        end
        # set this to nil so that files_to_final_location
        # fails to run in the Attachment class
        @temp_file = nil
      end
      
      def delete_from_fog_storage
        RedmineFog::Storage.delete_from_fog_storage self.disk_filename
      end
    end
  end
end