require 'redmine_fog/attachment_patch'
require 'redmine_fog/attachments_controller_patch'
require 'redmine_fog/attachments_helper_path'

Attachment.send(:include, RedmineFog::AttachmentPatch)
AttachmentsController.send(:include, RedmineFog::AttachmentsControllerPatch)
AttachmentsHelper.send(:include, RedmineFog::AttachmentsHelperPatch)