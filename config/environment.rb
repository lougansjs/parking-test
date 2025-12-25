require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'] || :development)

# Load Mongoid config
Mongoid.load!(File.join(File.dirname(__FILE__), 'mongoid.yml'))

# TODO: Talvez exista uma maneira melhor de carregar os arquivos, 
# ver isso se sobrar tempo.
Dir[File.join(File.dirname(__FILE__), '../app/domain/value_objects/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/models/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/repositories/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/services/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/api/v1/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/api/*.rb')].each { |f| require f }
