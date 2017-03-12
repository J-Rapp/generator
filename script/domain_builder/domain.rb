module DomainBuilder
  class Domain
    attr_reader :name, :html_files

    def initialize(data)
      @name = data[:name]
      @keywords = data[:keywords]
      @videos = data[:videos]
      @videos = data[:videos]
      @facebook = data[:facebook]

      @html_files = {}
    end

    def build
      generate_html_files
    end

    private

    def generate_html_files
      @keywords.each do |keyword|
        @html_files[keyword] = {
          path: create_filename(keyword),
          html: build_html_string(keyword)
        }
      end
    end

    def create_filename(keyword)
      # downcase and remove leading/trailing whitespace
      keyword = keyword.downcase.strip

      # remove certain non-english characters
      keyword = keyword.gsub(/[å]/, 'aa')
      keyword = keyword.gsub(/[ø]/, 'oe')
      keyword = keyword.gsub(/[æ]/, 'ae')

      # remove special characters and spaces
      keyword = keyword.gsub(/[^0-9A-Za-z]/, '-')

      # cap filename at 250 characters
      keyword = keyword.slice(0..249)

      keyword + '.html'
    end

    def build_html_string(keyword)
      File.read(TEMPLATE)
    end
  end
end
