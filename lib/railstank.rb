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

    class << self

      def included(klass)
        klass.send :include, InstanceMethods
        klass.instance_variable_set('@client', @client)
        klass.extend ClassMethods
      end
    end

    module ClassMethods

      attr_accessor :text_indexes

      def client
        client = Railstank.client
      end

      def has_indextank(name,options={})
        indextank_index_name = name.to_s

        define_method "text_indexes" do
          client.indexes indextank_index_name
        end

        @text_indexes = client.indexes indextank_index_name
      end

      def isearch(field,options={})
        fetch_id_type = options[:fetch]
        results = text_indexes.search(field,options)["results"]
        result_ids = results.map{ |result| result[fetch_id_type] }.uniq
      end
    end

    module InstanceMethods
      
      def client
        parent_class.client
      end

      def add_to_search_index(content_hash)
        text_indexes.document("#{parent_class_name}_#{self.id}").add(content_hash)
      end

      def delete_index
        text_indexes.document("#{parent_class_name}_#{self.id}").delete
      end

      def parent_class
        self.class
      end
      
      def parent_class_name
        parent_class.name.underscore
      end

      protected
    end
  end
end
