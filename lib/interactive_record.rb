require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  
  def self.table_name
    self.to_s.downcase.pluralize
  end
  
  def self.column_names
    DB[:conn].results_as_hash = true
    
    sql = "PRAGMA table_info('#{table_name}')"
    
    info = DB[:conn].execute(sql)
    
    column_names = []
    
    info.each do |column|
      column_names << column["name"]
    end
    column_names.compact
  end
  
  self.column_names.each do |name|
    attr_accessor name.to_sym
  end
  
  def initialize(options = {})
    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end
  
  def table_name_for_insert
    
  end
  
end