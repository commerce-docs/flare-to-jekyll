require 'converters/link.rb'

RSpec.describe LinkConverter do
  include LinkConverter
  context 'with an internal link' do
    it 'converts the link to jekyll format' do
      expect(convert_relative_url(link: '../magento/release-notes.htm', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
    it 'removes references to sections' do
      expect(convert_relative_url(link: '../magento/release-notes.htm#SectionName', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
    it 'removes references to sections that contain a path' do
      expect(convert_relative_url(link: '../magento/release-notes.htm#SectionName/ajaljn.html', abs_path: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content/backmatter/appendix.htm', base_dir: '/Users/dmytroshevtsov/Projects/repos/magento-merchdocs/master-m2.3/Content', from_ext: 'htm', to_ext: 'md')).to eq '{{ site.baseurl }}{% link magento/release-notes.md %}'
    end
  end
  context 'with an image link' do
    it 'converts the link to Jekyll format' do
      expect(convert_img_src link: '../Resources/Images/storefront-about-us.png').to eq '{{ site.baseurl }}{% link images/images/storefront-about-us.png %}'
    end
  end
end
