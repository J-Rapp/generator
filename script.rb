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

# returns an array of domain hashes
domains = DataProcessor.call

puts 'Data ingested successfully'


# # 3) Create and open a new '/domains' directory

# delete '/domains' if it exists already
FileUtils.rm_r Dir.glob('domains') if Dir.exist?('domains')
Dir.mkdir('domains')
Dir.chdir('domains')


# # 4) iterate over data

puts 'Creating each subdomain in /domains...'

counter = 0
domain_count = domains.count

domains.each do |data|
  # # 5) generate a new subdirectory for each domain

  Dir.mkdir(data[:name])
  Dir.chdir(data[:name])

  # # 6) build all the HTML strings for the domain

  domain = DomainBuilder.call(data)

  # # 7) creates an html file from each string

  domain.html_file_paths.each do |path|
    File.new(path, 'w')
  end

  # # 8) include asset files from the template

  # progress display
  counter += 1
  # 'print' required because 'puts' starts a new line
  print "#{counter} out of #{domain_count}"
  print "\r"

  # return to /domains directory
  Dir.chdir('..')
end

puts 'Script complete'
