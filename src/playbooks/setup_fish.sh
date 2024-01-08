#!/usr/bin/env fish

# install python venv
echo "<----- installing python virtual environment ----->"
python -m venv ./.venv
source ./.venv/bin/activate.fish

echo "<----- installing python dependencies ----->"
pip install -r ./requirements.txt