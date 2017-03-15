require 'fileutils'


# # 1) Require all files from the nested /script directory

def require_all(dir)
  files = Dir.glob File.join(dir, '**', '*.rb')
  files = files.map { |fyle| File.expand_path fyle }.sort
  files.each do |fyle|
    Kernel.send(:require, fyle)
  end
end

require_all('script')

puts 'Script loaded successfully.'



# # 2) Process the data

# 'print' required for rewriting output line because 'puts' starts a new line
print 'Ingesting data files...'
# return cursor to beginning of terminal output line
print "\r"

# returns an array of domains from the .tsv file rows
domains = DataProcessor::Domains.new.ingest
# returns an array of all words
words = File.read(WORDLIST_PATH).split

puts 'Data ingested successfully.'



# # 3) Create the file that will store all the urls of every domain

master_file = File.open('urls.txt', 'w+')



# # 4) Create and open a new '/domains' directory

# delete '/domains' if it exists already
FileUtils.rm_r Dir.glob('domains') if Dir.exist?('domains')

Dir.mkdir('domains')
Dir.chdir('domains')



# # 5) iterate over the domains and build them

counter = 0
domain_count = domains.count

domains.each do |domain|
  # # 6) generate a new directory (with assets) for each domain

  FileUtils.copy_entry(TEMPLATE_ASSETS_DIR, domain[:name])
  Dir.chdir(domain[:name])


  # # 7) build all the HTML strings for the domain
  domain = DomainBuilder.call(domain, words)


  # # 8) create all .html files and add them in master .txt file

  domain.html_files.each do |keyword, file_data|
    File.open(file_data[:path], 'w+') do |f|
      f.write file_data[:html]
    end
    master_file.puts "\"#{keyword}\", http://www.#{domain.name}/#{file_data[:path]}"
  end


  # # 9) display progress

  counter += 1
  print "#{counter} of #{domain_count} domains complete"
  print "\r"


  # # 10) return to /domains directory to create the next domain
  Dir.chdir('..')
end

puts 'Script complete. Domains can be found in the /domains directory.'
