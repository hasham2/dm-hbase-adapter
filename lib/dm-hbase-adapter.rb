require 'dm-core'
require 'dm-core/adapters/abstract_adapter'
require 'stargate'
require 'ruby-debug'
module DataMapper::Adapters
  
  class HbaseAdapter < AbstractAdapter

    def initialize(name, options)
      super
      @options[:hostname] ||= 'localhost'
      @options[:port] ||= 8080
      @db = Stargate::Client.new("http://#{@options[:hostname]}:#{@options[:port]}")
    end

    def create(resources)
      created = 0
      resources.each do |resource|
        initialize_serial(resource, Time.now.to_i) #set the key as Timestamp
        if save(resource.model.storage_name, key(resource), resource)
          created += 1
        end
      end
      created
    end

    def read(query)
      records = []
      scanner = @db.open_scanner(query.model.storage_name)
      rows = @db.get_rows(scanner)
      @db.close_scanner(scanner)
      rows.each do |row|
        record = Hash.new
        row.columns.each do |col|
          record.merge!({col.name => col.value})
        end
       records << record
      end
      query.filter_records(records)
    end

    def update(attributes, collection)
      updated = 0
      collection.each do |resource|
        if update(resource.model.storage_name, key(resource), resource, attributes)
          updated += 1
        end
      end
      updated 
    end

    def delete(collection)
      deleted = 0
      collection.each do |resource|
        if @db.delete_row(resource.model.storage_name, key(resource))
          deleted += 1
        end
      end
      deleted 
    end

    protected

    def key(resource)
      model = resource.model
      key = resource.key.join('/')
      "#{model}/#{Time.now}"
    end

    def save(table, identifier, resource)
      saved = true
      attrs = []
      resource.attributes.each_pair do |key, val|
        attrs << {:name => 'attribute:'+key.to_s, :value => val}
      end
      unless @db.create_row(table, identifier, Time.now.to_i, attrs)
        return false
      end
      saved
    end

    def update(column_family, identifier, resource, attributes)
      attributes.each_pair do |key, val|
        unless @db.delete_row(column_family, identifier, nil, key)
          return false
        else
          unless @db.create_row(column_family, identifier, Time.now.to_i, {:key => key, :value => val})
            return false
          end
        end
      end
      true
    end

  end

end
