# Flare to Jekyll converter

The goal of this project is to convert Magento Merchant Documentation written in Flare format to the format consumable by Jekyll to unify the documentation processing with the DevDocs project.

To test the script:

- clone the repo with documentation to convert
- set up [configuration](config.yml):
  - source directory: `flare_dir:`
  - destination directory: `jekyll_dir:`
- run the converter
- review content in the destination directory

## Install packages

```bash
bundle install
```

## Run the converter

```bash
bundle exec flare-to-jekyll
```

## Testing

To run tests:

```bash
bin/rspec --format doc
```