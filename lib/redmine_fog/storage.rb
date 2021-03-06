require 'fog'

module RedmineFog
  class Storage
  
    @@connection = nil
    @@fog_options = {}
    
    class << self
    
      def load_options
        file = ERB.new(File.read(File.join(Rails.root, 'config', 'fog.yml'))).result
        YAML::load( file )[Rails.env].each do |key, value|
         @@fog_options[key.to_sym] = value
        end
      end
      
      def establish_connection
        load_options unless self.has_fog_options
        @@connection = Fog::Storage.new({
            :provider            => @@fog_options[:provider],         # Rackspace Fog provider
            :rackspace_username  => @@fog_options[:rackspace_username], # Your Rackspace Username
            :rackspace_api_key   => @@fog_options[:rackspace_api_key],       # Your Rackspace API key
            :rackspace_region    => @@fog_options[:rackspace_region] || :dfw,                # Defaults to :dfw
            :connection_options  => {}                   # Optional
        })
      end
      
      def has_fog_options
        @@fog_options[:rackspace_username] && @@fog_options[:rackspace_api_key] && @@fog_options[:rackspace_container] && @@fog_options[:rackspace_cdn_url]
      end
      
      def connection
        @@connection || establish_connection
      end
      
      def directory
        self.connection.directories.get @@fog_options[:rackspace_container]
      end
      
      def move_to_fog_storage(filename, content, content_type='application/octet-stream')
        file = self.directory.files.create :key => filename, :body => content, :content_type => content_type
      end
      
      def file_url(filename)
        load_options unless self.has_fog_options
        "#{@@fog_options[:rackspace_cdn_url]}/#{filename}"
      end
      
      def delete_from_fog_storage(filename)
        file = self.directory.files.create :key => filename
        file.destroy
      end
    
    end
  end
end