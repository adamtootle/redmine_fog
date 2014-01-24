module RedmineFog
  module AttachmentsHelperPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        def link_to_attachments(container, options = {})
          options.assert_valid_keys(:author, :thumbnails)
          
          if container.attachments.any?
            options = {:deletable => container.attachments_deletable?, :author => true}.merge(options)
            render :partial => '../../plugins/redmine_fog/views/attachments/links',
              :locals => {
                          :attachments => container.attachments, 
                          :options => options, 
                          :thumbnails => (options[:thumbnails] && Setting.thumbnails_enabled?)
                          }
          end
        end
      end
    end
  end
end