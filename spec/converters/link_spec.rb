require 'converters/link.rb'

RSpec.describe LinkConverter do
  include LinkConverter
  context 'with internal links' do
    it 'converts links to jekyll format' do
      expect(convert_a_href(link: '../magento/release-notes.htm', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
    it 'removes references to sections' do
      expect(convert_a_href(link: '../magento/release-notes.htm#SectionName', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
    it 'removes references to sections that contain a path' do
      expect(convert_a_href(link: '../magento/release-notes.htm#SectionName/ajaljn.html', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
    it 'ignores external links' do
      expect(convert_a_href(link: 'https://docs.magento.com/m2/ee/user_guide/catalog/categories-content-settings.html', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content')).to eq 'https://docs.magento.com/m2/ee/user_guide/catalog/categories-content-settings.html'
    end
  end
end
