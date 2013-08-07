require 'factory_girl'
Dir[File.expand_path("test/factories/*.rb", Rails.root)].each do |file|
  require file
end

FactoryGirl.create :season, schedule: true
