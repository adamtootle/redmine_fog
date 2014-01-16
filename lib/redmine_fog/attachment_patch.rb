module RedmineFog
  module AttachmentPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
    end
  end
end