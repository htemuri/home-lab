#!/usr/bin/env bash

# install python venv
python -m venv ./.venv
source ./.venv/bin/activate
pip install -r ./requirements.txt