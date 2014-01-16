require 'redmine_fog/attachment_patch'

Attachment.send(:include, RedmineFog::AttachmentPatch)