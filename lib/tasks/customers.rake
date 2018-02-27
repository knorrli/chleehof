namespace :customers do

  desc 'import customers from CSV'
  task :import, [:path] => :environment do |_, args|
    filename = args[:path]
    raise "Please enter filename" if filename.empty?
    CustomerImporter.run(filename)
  end
end
