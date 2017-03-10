# Running the script locally

1. Replace or copy/paste data into the appropriate files in the `/data` directory.
  1. The data file is currently `.tsv` format - this is near identical to the `.csv` format except columns are delimited by tabs instead of commas. Excel and Google Sheets are able to export worksheets in `.tsv` format.
  2. The data sheet must contain the columns `niche`, `domain`, `keywords`, `facebook`, `popuptext`, and `videos`, in no particular order.
  3. All cells containing a list/array of values must be demilited by commas.
2. With Ruby installed on your local machine, run `ruby generate_sites.rb` from your command line while inside this `/generator` directory.
3. A `/sites` directory will be created, with subdirectories of every domain inside.

# Logic overview

First, it ingests the files within the `/input_data_here` directory. This data is then handed off to the `/site_generator/single_site_builder` directory where the HTML string is assembled. The script then neatly assembles new `/sites` directory containing subdirectories of ready-to-host static websites, each with multiple HTML pages and any required assets.

# Switching HTML templates when desired

(WIP) ... These are where the various HTML swap-outs can be made for the new template, adding, altering, or removing components as needed. The various assets (CSS, JS, etc) are a bit less complicated, needing only a quick replace or copy/paste in the `/site_generator/html_template_assets` directory.