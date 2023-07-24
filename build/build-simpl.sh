#!/usr/bin/env bash

## build.sh: compile manuscript outputs from content using Manubot and Pandoc

set -o errexit \
    -o nounset \
    -o pipefail

# Set timezone used by Python for setting the manuscript's date
export TZ=Etc/UTC
# Default Python to read/write text files using UTF-8 encoding
export LC_ALL=en_US.UTF-8


# Set DOCKER_RUNNING to true if docker is running, otherwise false.
DOCKER_RUNNING="$(docker info &> /dev/null && echo "true" || (true && echo "false"))"

# Set option defaults
CI="${CI:-false}"
BUILD_PDF="${BUILD_PDF:-true}"
BUILD_DOCX="${BUILD_DOCX:-true}"
BUILD_LATEX="${BUILD_LATEX:-false}"
SPELLCHECK="${SPELLCHECK:-false}"
MANUBOT_USE_DOCKER="${MANUBOT_USE_DOCKER:-$DOCKER_RUNNING}"
FECHA_COMPILACION="${COMPILATION_DATE}"
COMMIT="${TRIGGERING_SHA_7}"
# Pandoc's configuration is specified via files of option defaults
# located in the $PANDOC_DATA_DIR/defaults directory.
PANDOC_DATA_DIR="${PANDOC_DATA_DIR:-build/pandoc}"
export FECHA_COMPILACION COMMIT PROYECTO PROY_DESCR
export PR04 PR05

# Make output directory
mkdir -p output

# Add commit hash / variables to the manuscript
envsubst < output/manuscript.md > output/manuscript.hash
mv output/manuscript.hash output/manuscript.md

# Create HTML output
# https://pandoc.org/MANUAL.html
echo >&2 "Exporting HTML manuscript"
pandoc --verbose \
  --data-dir="$PANDOC_DATA_DIR" \
  --defaults=common.yaml \
  --defaults=html.yaml


# Create DOCX output (if BUILD_DOCX environment variable equals "true")
if [ "${BUILD_DOCX}" = "true" ]; then
  echo >&2 "Exporting Word Docx manuscript" "--fecha ${FECHA_COMPILACION}"
  # for f in content/*.md; do
  #   basenameFILE=${f##*/};
  #   
  #   # Add commit hash to the MD
  #   envsubst < "$f" > mdfile.hash
  #   mv mdfile.hash "$f"

  #   echo "sustituya < $f > $f.hash"

  #   pandoc --verbose \
  #     --data-dir="$PANDOC_DATA_DIR" \
  #     --defaults=common-i.yaml \
  #     --defaults=docx-i.yaml \
  #     --output=output/"${basenameFILE%.md}.docx" \
  #     "$f"
  #   
  # done

  pandoc --verbose \
    --data-dir="$PANDOC_DATA_DIR" \
    --defaults=common.yaml \
    --defaults=docx-i.yaml \
    --output=output/manuscript-simpl.docx" \
fi
