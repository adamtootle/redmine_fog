require 'redmine_fog/attachment_patch'
require 'redmine_fog/attachments_controller_patch'
require 'redmine_fog/storage'

Attachment.send(:include, RedmineFog::AttachmentPatch)
AttachmentsController.send(:include, RedmineFog::AttachmentsControllerPatch)