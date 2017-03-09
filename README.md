# Setting it up locally

1) Copy/paste your data into the appropriate files in the `/data` directory.
2) With Ruby installed on your local machine, run `ruby script.rb` from your command line while inside this `/generator` directory.
3) A `/sites` directory will be created, with subdirectories of every domain inside.

# Switching HTML templates when desired

The `/sites` directory contains a fair attempt at separating the concerns of this program. The `/data_processor` directory first interprets the files in the `/data` directory. This pure string data is then handed off to the `/html_builder` directory where the actual HTML string is assembled. These are where the various HTML swap-outs can be made for the new template, adding, altering, or removing components as needed. The various assets (CSS, JS, etc) are a bit less complicated, needing only a quick copy/paste in the `/assets` directory.