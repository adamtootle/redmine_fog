module RedmineFog
  module AttachmentsControllerPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        before_filter :download_from_fog_storage, :except => [:destroy, :upload]
        skip_before_filter :file_readable
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def download_from_fog_storage
        if @attachment.container.is_a?(Version) || @attachment.container.is_a?(Project)
          @attachment.increment_download
        end
        redirect_to(RedmineFog::Storage.file_url(@attachment.disk_filename))
      end
    end
  end
end