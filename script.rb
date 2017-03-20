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



# # 3) Create '/domains' directory and 'urls.txt'

# delete if they exist already
FileUtils.rm_r Dir.glob('domains') if Dir.exist?('domains')
File.delete(MASTER_URL_FILE) if File.exist?(MASTER_URL_FILE)

File.new(MASTER_URL_FILE, 'w+')
Dir.mkdir('domains')
Dir.chdir('domains')



# # 4) iterate over the domains, only building the urls.txt file

domains.each do |domain|
  domain = DomainBuilder.filenames(domain)
  domain.files.each do |keyword, file_data|
    File.open(MASTER_URL_FILE, 'a') do |f|
      f.puts "http://www.#{domain.name}/#{file_data[:path]},#{keyword}"
    end
  end
end



# # 5) iterate a second time, now building all the html strings

counter = 0
domain_count = domains.count
puts 'Creating all html pages (this may take a while)...'

domains.each do |domain|
  # # 5) display progress along the way

  print "#{counter} of #{domain_count} domains complete."
  print "\r"
  counter += 1


  # # 6) generate a new directory (with assets) for each domain

  FileUtils.copy_entry(TEMPLATE_ASSETS_DIR, domain[:name])
  Dir.chdir(domain[:name])


  # # 7) build all the HTML strings for the domain

  domain = DomainBuilder.html(domain, words)


  # # 8) create all .html files and add them in master .txt file

  domain.files.each do |keyword, file_data|
    File.open(file_data[:path], 'w+') do |f|
      f.write file_data[:html]
    end
  end


  # # 10) add an .htaccess file

  File.open('.htaccess', 'w+') do |f|
    f.write 'Redirect 301 / ' + '/blog/url-string' # what should this be?
  end

  # # 11) return to /domains directory to create the next domain
  Dir.chdir('..')
end

puts "#{counter} of #{domain_count} domains complete."
puts 'Script complete - /domains created.'
