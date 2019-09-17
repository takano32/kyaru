require 'yaml'
require "sequel"

database_url = ""
begin
  yaml = YAML.load_file("../config.yml")
  database_url  = yaml['database_url']
rescue
  database_url  = ENV['DATABASE_URL']
end

db = Sequel.connect database_url
db.create_table :money do
  primary_key   :id
  Integer       :amount
end