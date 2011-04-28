module Railstank
  
  class Error < StandardError; end
  
  def self.config(environment=RAILS_ENV)
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(RAILS_ROOT + '/config/indextank.yml').read)[environment]
  end
  
  def self.client
    @client = IndexTank::Client.new config["api_url"]
  end
  
  module Search
    extend ActiveSupport::Concern
    included do

    end
      
    module ClassMethods
      attr_accessor :index_name, :search_index
      
      def has_indextank(class_index_name,options={})
        indextank_index_name = class_index_name.to_s
        
        define_method "index_name" do
          indextank_index_name
        end  
        define_method "search_index" do
          Railstank.client.indexes indextank_index_name
        end
        
        define_method "index_class_name" do
          options[:index_class_name].present? ? options[:index_class_name].to_s.underscore : self.class.name.underscore
        end
        
        @index_name = indextank_index_name
        @search_index = Railstank.client.indexes indextank_index_name
      end
      
      def isearch(field,options={})
        fetch_id_type = options[:fetch]
        results = search_index.search(field,options)["results"]
        result_ids = results.map{ |result| result[fetch_id_type] }.uniq
      end
    end

    module InstanceMethods
      def add_to_search_index(content_hash)
        search_index.document("#{index_class_name}_#{self.id}").add(content_hash)
      end
      
      def delete_index
        search_index.document("#{index_class_name}_#{self.id}").delete
      end
      
      protected
    end
  end
end
