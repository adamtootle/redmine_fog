require 'redmine_cloud_files/attachment_patch'

Attachment.send(:include, RedmineCloudFiles::AttachmentPatch)