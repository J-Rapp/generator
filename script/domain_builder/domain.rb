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
      @titles = grab_title_templates
      @metas = grab_meta_templates
    end

    def build
      make_index_page
      generate_html_files
    end

    private

    def grab_title_templates
      file = File.open(TITLES_PATH)
      titles = []
      file.each_line { |line| titles << line.strip }
      titles
    end

    def grab_meta_templates
      file = File.open(META_PATH)
      metas = []
      file.each_line { |line| metas << line.strip }
      metas
    end

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

    def facebook_tag
      @facebook
    end

    def random_five_keywords
      rand_keys = []
      5.times { rand_keys << @keywords.sample }
      rand_keys
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
      rand(2..15).times { h2 << @wordlist.sample }
      h2 << keyword.split(' ')
      h2 = h2.flatten.shuffle
      h2.join(' ')
    end

    def random_paragraph(keyword)
      paragraph = ''
      7.times { paragraph += random_sentence(keyword) }
      # TODO: insert random lists
      paragraph
    end

    def random_sentence(page_keyword)
      sentence = []
      # between 1500-2500 total words on the page
      # 84 sentences on the page = 17-29 words per sentence
      rand(17..29).times do
        sentence << @wordlist.sample
      end
      normalize(sentence, page_keyword)
    end

    def normalize(sentence, page_keyword)
      indices = (2..(sentence.length - 2)).to_a
      # add random punctuation and keywords/links
      sentence[indices.sample] += random_punctuation if percent_chance(30)
      sentence.insert(indices.sample, page_keyword) if percent_chance([0.5, 1, 1.5, 2].sample)
      sentence.insert(indices.sample, @keywords.sample) if percent_chance([2, 2.5, 3, 3.5, 4, 4.5, 5].sample)
      sentence.insert(indices.sample, keyword_link) if percent_chance(8)
      # TODO: includes links to another domain
      sentence.join(' ').capitalize + '. '
    end

    def percent_chance(float)
      # working with 200 instead of 100 allows for half decimal usage
      likelikood = float * 2
      two_hunnid = (1..200).to_a
      picks = two_hunnid.sample(likelikood)
      picks.include?(two_hunnid.sample)
    end

    def random_punctuation
      [':', ';', ',', ',', ','].sample
    end

    def keyword_link
      keyword = @keywords.sample
      '<a href="' + pathify(keyword) + '.html">' + keyword + '</a> '
    end

    def title_ize(keyword)
      @titles.sample.gsub('KEYWORD', keyword)
    end

    def meta_ize(keyword)
      @metas.sample.gsub('KEYWORD', keyword)
    end
  end
end
