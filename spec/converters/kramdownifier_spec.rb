require 'converters/kramdownifier.rb'

RSpec.describe Kramdownifier do
  include Kramdownifier

  context 'with a topic' do
    let(:doc) { parse_file(File.absolute_path('spec/samples/catalog-urls-dynamic-media.htm')) }

    it 'removes CDATA' do
      absolute_path = File.absolute_path 'spec/samples/catalog-create.htm'
      body_content = parse_file(absolute_path).at_css('body')
      expect(body_content.children.any?(&:cdata?)).to be false
    end
    it 'escapes {{ }} using Liquid tags' do
      safe_double_braced_content
      expect(to_xml).to include '{% raw %}'
    end
    it 'contains variables' do
      expect(variables).not_to be_empty
    end
    it 'replaces variables with Magento' do
      convert_variables
      expect(variables).to be_empty
    end
  end
  context 'with a note' do
    let(:note) { Nokogiri::XML '<p class="noteAfterAlpha">The "Sign up to get notified when this product is back in stock" message appears only when Inventory Stock Options - Display Out of Stock Products is set to “Yes.” <br/></p>' }
    it 'converts a note' do
      convert_a_note(note.root)
      expect(note.to_html).to include '<div class="bs-callout bs-callout-info" markdown="1">The "Sign up to get notified when this product is'
    end
  end
  it 'converts dropdown to Liquid collapsible' do
    expect(replace_collapsibles_in '<dropDownBody markdown="1">Some text here</dropDownBody>').to eq "\n{% collapsible %}\nSome text here\n{% endcollapsible %}\n"
  end
  it 'converts conditionalText to Liquid conditional' do
    expect(convert_conditional_text 'The Catalog Menu provides easy access to product creation, category and inventory management tools<conditionalText conditions="Default.EE Only,Default.CE Only">.</conditionalText><conditionalText conditions="Default.B2B Only">, as well as shared catalogs for custom pricing.</conditionalText>').to eq 'The Catalog Menu provides easy access to product creation, category and inventory management tools{% if "Default.EE Only,Default.CE Only" contains site.edition %}.{% endif %}{% if "Default.B2B Only" contains site.edition %}, as well as shared catalogs for custom pricing.{% endif %}'
  end
  context 'with a conditional tag' do
    let(:tag) { Nokogiri::XML '<img src="{{ site.baseurl }}{% link images/images/admin-menu-catalog.png %}" class="large" conditions="Default.CE Only"/>' }
    it 'converts a tag with conditions to Liquid' do
      convert_a_tag_with_condition tag.root
      expect(tag.to_xml).to include "<!--{% if \"Default.CE Only\" contains site.edition %}-->\n<img src=\"{{ site.baseurl }}{% link images/images/admin-menu-catalog.png %}\" class=\"large\"/>\n<!--{% endif %}-->"
    end
  end
  context 'with page with conditional tags' do
    let(:doc) { parse_file(File.absolute_path('spec/samples/catalog-menu.htm')) }
    it 'finds conditions' do
      expect(conditions).not_to be_empty
    end

    it 'does not find conditions after conversion' do
      convert_conditions
      expect(conditions).to be_empty
    end
  end
  context 'with page with conditional in root' do
    let(:doc) { parse_file(File.absolute_path('spec/samples/account-company-users.htm')) }
    it 'finds conditions' do
      expect(conditions).to be_empty
    end

    it 'does not find conditions after conversion' do
      origin = doc.dup
      convert_conditions
      expect(doc.to_xml).to eq origin.to_xml
    end
  end
end
