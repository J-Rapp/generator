# Running the script locally

1. Replace or copy/paste data into the appropriate files in the `/data` directory.
  1. The data file containing rows of domains is currently `.tsv` format (see below).
  2. The domain data sheet column headers must be `niche`, `name`, `keywords`, `facebook`, `popuptext`, and `videos`, in no particular order.
  3. All cells containing a list/array of values must be demilited by commas.
  4. Any changes to domain data path/naming should be updated in the `config.rb` file so the script knows where to look.
2. With Ruby installed on your local machine, run `ruby script.rb` from your command line while inside this `/generator` directory.
3. A `/domains` directory will be created with ready to be hosted domains.

* This is near identical to the `.csv` format except columns are delimited by tabs instead of commas. Excel and Google Sheets are able to export worksheets in `.tsv` format.

# Switching HTML templates when desired

The various assets (CSS, JS, etc) are a bit less complicated, needing only a quick replace or copy/paste in the `/site_generator/html_template_assets` directory.

<%= keyword %>
<%= first_keyword %>
<%= second_keyword %>
<%= third_keyword %>
<%= fourth_keyword %>
<%= fifth_keyword %>
<%= pathify(any_keyword) %>
<%= header(any_keyword) %>
<%= random_sentence(any_keyword) %>
<%= random_paragraph(any_keyword) %>
<%= title_ize(keyword) %>
<%= meta_ize(keyword) %>
<%= facebook_tag %>
