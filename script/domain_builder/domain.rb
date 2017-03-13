require 'erb'

module DomainBuilder
  class Domain
    attr_reader :name, :html_files

    def initialize(data)
      @name = data[:name]
      @keywords = data[:keywords]
      @videos = data[:videos]
      @popuptext = data[:popuptext]
      @facebook = data[:facebook]
      @html_files = {
        'index' => {
          path: 'index.html',
          html: build_html_string(@keywords.sample)
        }
      }
    end

    def build
      generate_html_files
    end

    private

    def generate_html_files
      @keywords.each do |keyword|
        @html_files[keyword] = {
          path: create_path(keyword),
          html: build_html_string(keyword)
        }
      end
    end

    def create_path(keyword)
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
      erb_template = File.read(TEMPLATE_PATH)
      random_keywords = random_five_keywords

      ERB.new(erb_template).result(binding)
    end

    def random_index
      Random.rand(0..4)
    end

    def random_five_keywords
      rand_keywords = []
      5.times { rand_keywords << @keywords.sample }
      rand_keywords
    end
  end
end
