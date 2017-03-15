require 'erb'

module DomainBuilder
  class Domain
    attr_reader :name, :html_files

    def initialize(data, words)
      @name = data[:name]
      @keywords = data[:keywords]
      @videos = data[:videos]
      @popuptext = data[:popuptext]
      @facebook = data[:facebook]
      @html_files = {}
      @wordlist = words
    end

    def build
      make_index_page
      generate_html_files
    end

    private

    def make_index_page
      @html_files['index'] = {
        path: 'index.html',
        html: build_html_string(@keywords.sample)
      }
    end

    def generate_html_files
      @keywords.each do |keyword|
        @html_files[keyword] = {
          path: pathify(keyword) + '.html',
          html: build_html_string(keyword)
        }
      end
    end

    # # Everything below pertains to generating html from the erb template

    def build_html_string(keyword)
      erb_template = File.read(TEMPLATE_PATH)
      random_keywords = random_five_keywords
      first_keyword = random_keywords[0]
      second_keyword = random_keywords[1]
      third_keyword = random_keywords[2]
      fourth_keyword = random_keywords[3]
      fifth_keyword = random_keywords[4]

      # render the html string
      ERB.new(erb_template).result(binding)
    end

    def random_five_keywords
      rand_keys = []
      5.times { rand_keys << @keywords.sample }
      rand_keys
    end

    def random_index
      Random.rand(0..4)
    end

    def pathify(keyword)
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

      keyword
    end

    def jumble(keyword)
      h2 = []
      Random.rand(2..15).times { h2 << @wordlist.sample }
      h2 << keyword.split(' ')
      h2 = h2.flatten.shuffle
      h2.join(' ')
    end
  end
end
