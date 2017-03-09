# Running the script locally

1. Replace or copy/paste data into the appropriate files in the `/data` directory.
2. With Ruby installed on your local machine, run `ruby script.rb` from your command line while inside this `/generator` directory.
3. A `/sites` directory will be created, with subdirectories of every domain inside.

# Logic overview

The `/site_generator` directory contains a fair attempt at separating the concerns of this program. First, the `/site_generator/data_processor` directory/module ingests the files within the `/input_data_here` directory. This data (likely to be a single nested data structure) is then handed off to the `/site_generator/single_site_builder` directory where the HTML string is assembled. The script then neatly assembles new `/sites` directory containing subdirectories of ready-to-host static websites, each with multiple HTML pages and any required assets.

# Switching HTML templates when desired

(WIP) ... These are where the various HTML swap-outs can be made for the new template, adding, altering, or removing components as needed. The various assets (CSS, JS, etc) are a bit less complicated, needing only a quick replace or copy/paste in the `/site_generator/html_template_assets` directory.