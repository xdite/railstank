module Railstank
  class Error < StandardError; end

  def self.config(environment=Rails.env)
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(RAILS_ROOT + '/config/indextank.yml').read)[environment]
  end
end
