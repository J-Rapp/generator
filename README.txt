# Running the script locally

1. Copy/paste your data into the appropriate files in the `/data` directory.
2. With Ruby installed on your local machine, run `ruby script.rb` from your command line while inside this `/generator` directory.
3. A `/sites` directory will be created, with subdirectories of every domain inside.

# Logic overview

The `/generate_sites` directory contains a fair attempt at separating the concerns of this program. The `/data_processor` directory first interprets the files in the `/input_data_here` directory. This data (likely to be a single nested data structure) is then iterated over and handed off to the `/single_site_builder` directory where the actual index page HTML string is assembled. The script then neatly assembles a dictory containing a ready-to-host static website with 150 html pages and assets.

# Switching HTML templates when desired

... These are where the various HTML swap-outs can be made for the new template, adding, altering, or removing components as needed. The various assets (CSS, JS, etc) are a bit less complicated, needing only a quick copy/paste in the `/assets` directory.