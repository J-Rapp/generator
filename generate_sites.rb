# From the 'require_all' gem
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

# 1) Require all files needed to run the script
require_all('site_generator')
puts 'Script load successfully'

# # 2) Create a new 'sites' directory
# Dir.mkdir('sites')
# Dir.chdir('sites')

# # 3) Process the data
# sites = DataProcessor.call

# # 4) iterate over data
# sites.each do |site|
#   # 5) generate a new subdirectory for each site
#   Dir.mkdir(site.domain)

#   # 6) build the giant html string for each site keyword
#   site.keywords.each do |keyword|
#     html_string = SingleSiteBuilder.call
#     # 7) creates an html file from each string
#     # 8) include asset files from the template
#   end 
# end

# # throughout each step - print out progress to the console
