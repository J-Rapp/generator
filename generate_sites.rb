require 'csv'
require 'fileutils'

# # 1) Mock 'require_all' gem functionality for nested directories

def require_all(dir)
  files = Dir.glob File.join(dir, '**', '*.rb')
  files = files.map { |fyle| File.expand_path fyle }.sort
  loop do
    failed = []
    first_error = nil
    files.each do |fyle|
      begin
        Kernel.send(:require, fyle)
      rescue NameError => ex
        failed << fyle
        first_error ||= ex
      rescue ArgumentError => ex
        # Swallow occasional Active Record exceptions
        raise unless ex.message['is not missing constant']
        STDERR.puts 'Warning: require_all swallowed an error'
        STDERR.puts ex.backtrace[0..9]
      end
    end
    break if failed.empty?
    raise first_error if failed.size == files.size
    files = failed
  end
  true
end

require_all('site_generator')

puts 'Script loaded successfully'

# # 2) Process the data

# inputs data file from wherever config.rb declares it's located
# col_sep: arg is because .tsv files are delimited by tabs
# quote_char: arg is confirgured to avoid an error if quotes are in the data
csv = CSV.read(DATA_PATH, headers: true, col_sep: "\t", quote_char: '|')

# returns a large nested data structure for the html_builder
sites = csv.map do |row|
  domain = row.to_a
  Hash[domain.map { |key, value| [key.to_sym, value] }]
end

puts 'Data ingested successfully'

# # 3) Create and open a new 'sites' directory

# delete 'sites' if it exists already
FileUtils.rm_r Dir.glob('sites') if Dir.exist?('sites')
Dir.mkdir('sites')
Dir.chdir('sites')

puts 'New /sites directory created'

# # 4) iterate over data

sites.each do |site|
  # # 5) generate a new subdirectory for each site
  Dir.mkdir(site[:domain])

  # # 6) build the giant html string for each site keyword
  # site.keywords.each do |keyword|
  #   html_string = SingleSiteBuilder.call
  #   # # 7) creates an html file from each string
  #   # # 8) include asset files from the template
  # end
end

# # throughout each step - print out progress to the console
