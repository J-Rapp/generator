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

    def random_paragraph(keyword)
      paragraph = ''
      7.times { paragraph += random_sentence(keyword) }
      paragraph
    end

    def random_sentence(keyword)
      sentence = ''
      # between 1500-2500 total words on the page
      # the current template has 7 sentences + 7 paragraphs (11 sentences each)
      # so at 84 sentences that's 17..29 words per sentence
      Random.rand(17..29).times do
        sentence += @wordlist.sample + ' '
        # add random punctuation
        sentence.insert(-2, random_punctuation) if percent_chance(2)
        # includes page keyword
        sentence.insert(-1, keyword) if percent_chance(2)
        # includes other keywords
        sentence.insert(-1, keyword_or_link) if percent_chance([3, 4, 5].sample)
      end
      # end with a period
      sentence.insert(-2, '.')
      sentence.capitalize
    end

    def percent_chance(integer)
      one_hunnid = (1..100).to_a
      likelihood = one_hunnid.sample(integer)
      likelihood.include?(one_hunnid.sample)
    end

    def random_punctuation
      [':', ';', ',', ',', ','].sample
    end

    def keyword_or_link
      keyword = @keywords.sample
      # page should include 2-8 links to other pages on this domain
      if percent_chance(5)
        keyword = '<a href="' + pathify(keyword) + '.html">' + keyword + '</a> '
      end
      keyword
    end
  end
end
