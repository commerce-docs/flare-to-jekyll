# Flare to Jekyll converter

The goal of this project is to convert Magento Merchant Documentation written in Flare format to the format consumable by Jekyll to unify the documentation processing with the DevDocs project.

To tests the script:

- clone the repo with documentation to convert
- check configuration
- run the converter providing a path to directory with the cloned repository as an arument

## Available configuration

[`removed.yml`](remove.yml) defines two lists:
- `compeletely` that is a list of attribute names for elements to be removed compeletely. If an element contains atrribute with name listed here, the element and its content will be removed.
- `condition_only` that is a list of names of attributes to be removed. All attributes with names listed here will be removed. All other components of the element that contains the attribute will be kept the same.
- `element_itself` that is a list of XPath expressions for elements to remove (no matter where they are), but keep their children elements.

## Install Nokogiri

```bash
gem install nokogiri
```

## Run the script

```bash
ruby converter.rb <absolute/path/to/merch-docs-dir>
```
