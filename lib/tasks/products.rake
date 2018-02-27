namespace :products do

  desc 'import products from CSV'
  task :import, [:path] => :environment do |_, args|
    filename = args[:path]
    raise "Please enter filename" if filename.empty?
    ProductImporter.run(filename)
  end
end
