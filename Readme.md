# Flare to Jekyll converter

The goal of this project is to convert Magento Merchant Documentation written in Flare format to the format consumable by Jekyll to unify the documentation processing with the DevDocs project.

## Install packages

```bash
bundle install
```

## How to use

- clone the repo with documentation to convert (`magento-merchdocs/master-m2.3`), source directory in configuration
- clone jekyll infrastructure `magento/merchdocs`, destination directory in configuration
- set up [configuration](config.yml):
  - source directory: `flare_dir:`
  - destination directory: `jekyll_dir:`
- run the converter
- run jekyll server to preview the results in HTML

## Run the converter

```bash
bundle exec flare-to-jekyll
```

## Testing

To run tests:

```bash
bin/rspec --format doc
```