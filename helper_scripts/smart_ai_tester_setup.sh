#!/bin/bash
set -ex

# curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# Create a new Python virtual environment named 'test'
python3 -m venv test

# Activate the virtual environment
source test/bin/activate

# Upgrade the 'smart-ai-tester' package
pip install --upgrade smart-ai-tester
playwright install --with-deps

#Set Headless as false
export HEADLESS=false

# create a new directory named 'opt'
mkdir -p opt/input opt/output opt/test_data

# create a input/test.feature file
cat << 'EOF' > opt/input/test.feature
Feature: Open Google homepage

Scenario: User opens Google homepage
  Given I have a web browser open
  When I navigate to https://www.google.com
  Then I should see the Google homepage
EOF

# get gpt-4o model API key by asking user
echo "Enter your GPT-4o model API key:"
read -s GPT_4O_API_KEY

# Run the 'smart-ai-tester' command with the specified parameters
smart-ai-tester \
  --input-file opt/input/test.feature \
  --output-path opt/output \
  --test-data-path opt/test_data \
  --llm-model gpt-4o \
  --llm-model-api-key $GPT_4O_API_KEY
