require 'converters/link.rb'
require 'yaml'

RSpec.describe LinkConverter do
  include LinkConverter
  context 'with an internal link' do
    it 'converts the link to jekyll format' do
      expect(convert_relative_url(link: '../magento/release-notes.htm', abs_path: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{% link magento/release-notes.md %}'
    end
    it 'converts the deeply nested link to jekyll format' do
      expect(convert_relative_url(link: '../../system/web-setup-module-manager.htm', abs_path: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content/configuration/advanced/advanced.htm', base_dir: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{% link system/web-setup-module-manager.md %}'
    end
    it 'removes references to sections' do
      expect(convert_relative_url(link: '../magento/release-notes.htm#SectionName', abs_path: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{% link magento/release-notes.md %}'
    end
    it 'removes references to sections that contain a path' do
      expect(convert_relative_url(link: '../magento/release-notes.htm#SectionName/ajaljn.html', abs_path: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/user/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{% link magento/release-notes.md %}'
    end
    context 'with .md extension' do
      it 'returns true if the link was removed ' do
        expect(removed?('{% link design/merge-css.md %}')).to be true
      end
      it 'returns false if the link was not removed ' do
        expect(removed?('{% link stores/admin-actions-control.md %}')).to be false
      end
    end
  end
  context 'with an image link' do
    it 'converts the link in topic to Jekyll format' do
      expect(convert_img_src link: '../Resources/Images/storefront-about-us.png').to eq '{% link images/images/storefront-about-us.png %}'
    end
    it 'converts the link in include to Jekyll format' do
      expect(convert_img_src link: '../Images/storefront-about-us.png').to eq '{% link images/images/storefront-about-us.png %}'
    end
  end
  context 'with an include link' do
    it 'converts the link to Jekyll format' do
      expect(convert_include_src link: '../Resources/Snippets/Ship to Applicable Countries.flsnp').to eq 'ship-to-applicable-countries.md'
    end
  end
end
