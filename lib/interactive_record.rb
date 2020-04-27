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
  
  def initialize(options = {})
    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end
  
  def save
    DB[:conn].execute("INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES ?", values_for_insert)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid FROM #{table_name_for_insert}")
  end
  
  def table_name_for_insert
    self.class.table_name
  end
  
  def col_names_for_insert
    info = self.class.column_names.delete_if do |col|
      col == "id"
    end
    
    info.join(", ")
  end
  
  def values_for_insert
    
    values = []
    
    self.class.column_names.each do |col|
      values << "'#{send(col)}'" unless send(col).nil?
    end
    
    values.join(", ")
  end
  
end