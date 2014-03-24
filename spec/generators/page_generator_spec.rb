require 'spec_helper'

describe Taza::PageGenerator do
  include Helpers::Taza

  before(:each) do
    capture(:stdout) { Taza::SiteGenerator.new(['foo_site']).site }
  end

  context "taza page home foo_site" do
    context "creates" do

      let(:subject) { Taza::PageGenerator.new(['home', 'foo_site']) }
      let(:output) { capture(:stdout) { subject.page  }}

      it 'creates a checkout_page.rb' do
        expect(output).to include('lib/sites/foo_site/pages/home_page.rb')
        expect(File.exists?('lib/sites/foo_site/pages/home_page.rb')).to be_true
      end
      it 'creates a checkout_page_spec.rb' do
        expect(output).to include('lib/sites/spec/isolation/home_page_spec.rb')
        expect(File.exists?('lib/sites/spec/isolation/home_page_spec.rb')).to be_true
      end

      it 'gives message if site does not exist' do
        bar_page = capture(:stdout) { Taza::PageGenerator.new(['checkout', 'bar_site']).page }
        expect(bar_page).to include("No such site bar_site exists")
      end

      it 'generates a page that can be required' do
        output
        page_spec = 'lib/sites/spec/isolation/home_page_spec.rb'
        expect(system("ruby -c #{page_spec} > #{null_device}")).to be_true
      end

      it 'the page can be accessed from the site' do
        pending 'not sure we need this test now'
        stub_settings
        stub_browser
        @site_class.new.check_out_page
      end

      it 'the page can be accessed for its site' do
        pending 'not sure we need this test now'
      end
    end
  end

  context 'failing specs' do
    xit "should give you usage if you do not give two arguments" do
      PageGenerator.any_instance.expects(:usage)
      lambda { run_generator('page', [@page_name], generator_sources) }.should raise_error
    end

    xit "should give you usage if you give a site that does not exist" do
      PageGenerator.any_instance.expects(:usage)
      $stderr.expects(:puts).with(regexp_matches(/NoSuchSite/))
      lambda { run_generator('page', [@page_name, "NoSuchSite"], generator_sources) }.should raise_error
    end

    xit "should generate a page spec that can be required" do
      run_generator('page', [@page_name, @site_class.to_s], generator_sources)
      page_functional_spec = File.join(PROJECT_FOLDER, 'spec', 'isolation', @site_class.to_s.underscore, 'check_out_page_spec.rb')
      system("ruby -c #{page_functional_spec} > #{null_device}").should be_true
    end

    xit "should be able to access the generated page from the site" do
      run_generator('page', [@page_name, @site_class.to_s], generator_sources)
      stub_settings
      stub_browser
      @site_class.new.check_out_page
    end

    xit "should be able to access the generated page for its site" do
      stub_browser
      stub_settings
      new_site_class = generate_site('Pag')
      run_generator('page', [@page_name, @site_class.to_s], generator_sources)
      run_generator('page', [@page_name, new_site_class.to_s], generator_sources)
      new_site_class.new.check_out_page.class.should_not eql(@site_class.new.check_out_page.class)
    end
  end
end
