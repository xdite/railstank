require 'rails/generators/base'

class RailstankGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def copy_config_file
    copy_file "indextank.yml.example", "config/indextank.yml.example"
  end
  
  def copy_indextank_initializer
    copy_file "load_indextank.rb", "config/initializers/load_indextank.rb"
  end

end