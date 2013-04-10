Dir[File.expand_path('test/integration', Rails.root) + '/*helper.rb'].each do |h|
  require h
end
