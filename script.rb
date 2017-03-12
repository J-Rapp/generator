require 'fileutils'

# # 1) Require all files from /script nested directory

def require_all(dir)
  files = Dir.glob File.join(dir, '**', '*.rb')
  files = files.map { |fyle| File.expand_path fyle }.sort
  files.each do |fyle|
    Kernel.send(:require, fyle)
  end
end

require_all('script')

puts 'Script loaded successfully'

# # 2) Process the data

# returns an array of domains from the .tsv file rows
domains = DataProcessor.call

puts 'Data ingested successfully'

# # 3) Create and open a new '/domains' directory

# delete '/domains' if it exists already
FileUtils.rm_r Dir.glob('domains') if Dir.exist?('domains')
Dir.mkdir('domains')
Dir.chdir('domains')

# # 4) iterate over the domains and build them

puts 'Creating each subdomain in /domains...'

counter = 0
domain_count = domains.count

domains.each do |data|
  # # 5) generate a new subdirectory for each domain

  Dir.mkdir(data[:name])
  Dir.chdir(data[:name])

  # # 6) build all the HTML strings for the domain

  domain = DomainBuilder.call(data)

  # # 7) create all .html files

  domain.html_files.each do |filename, html_string|
    File.open(filename, 'w+') do |f|
      f.write html_string
    end
  end

  # # 8) include asset files from the template

  FileUtils.copy_entry(TEMPLATE_ASSETS, 'assets')

  # progress display
  counter += 1
  # 'print' required because 'puts' starts a new line
  print "#{counter} of #{domain_count} complete"
  print "\r"

  # return to /domains directory
  Dir.chdir('..')
end

puts 'Script complete'
