require 'spec_helper'

describe Taza::SiteGenerator do
  context "taza site foo_site" do
    context "creates" do

      let(:subject) { Taza::SiteGenerator.new(['foo_site']) }
      let(:output) { capture(:stdout) { subject.site } }

      it 'foo_site.rb' do
        expect(output).to include('lib/sites/foo_site.rb')
        expect(File.exists?('lib/sites/foo_site.rb')).to be_true
      end

      it 'lib/sites/foo_site' do
        expect(output).to include('lib/sites/foo_site')
        expect(File.directory?('lib/sites/foo_site')).to be_true
      end

      it 'lib/sites/foo_site/flows' do
        expect(output).to include("lib/sites/foo_site/flows")
        expect(File.directory?('lib/sites/foo_site/flows')).to be_true
      end

      it 'lib/sites/foo_site/pages' do
        expect(output).to include("lib/sites/foo_site/pages")
        expect(File.directory?('lib/sites/foo_site/pages')).to be_true
      end

      it 'lib/sites/foo_site/pages/partials' do
        expect(output).to include("lib/sites/foo_site/pages/partials")
        expect(File.directory?('lib/sites/foo_site/pages/partials')).to be_true
      end

      it 'config/foo_site.yml' do
        expect(output).to include("config/foo_site.yml")
        expect(File.exists?('config/foo_site.yml')).to be_true
      end

      it 'does not overwrite existing site' do
        capture(:stdout) { Taza::SiteGenerator.new(['foo_site']).site }
        expect(output).to include(*["identical", "exist"])
      end

      it "generates a site that can uses the block given in new" do
        pending 'will have to fix this later'
        @site_class = generate_site(@site_name)
        stub_settings
        stub_browser
        foo = nil
        @site_class.new { |site| foo = site }
        foo.should_not be_nil
        foo.should be_a_kind_of(Taza::Site)
      end
    end
  end

  context 'old failing specs' do
    xit "should generate configuration file for a site" do
      run_generator('site', [@site_name], generator_sources)
      File.exists?(File.join(PROJECT_FOLDER, 'config', 'wikipedia_foo.yml')).should be_true
    end

    xit "should generate a site path for pages" do
      run_generator('site', [@site_name], generator_sources)
      File.directory?(@site_folder).should be_true
    end

    xit "should generate a partials folder under pages" do
      run_generator('site', [@site_name], generator_sources)
      File.directory?(File.join(@site_folder, "pages", "partials")).should be_true
    end

    xit "should generate a folder for a sites isolation tests" do
      run_generator('site', [@site_name], generator_sources)
      File.directory?(File.join(PROJECT_FOLDER, 'spec', 'isolation', 'wikipedia_foo')).should be_true
    end

    xit "generated site that uses the block given in new" do
      @site_class = generate_site(@site_name)
      stub_settings
      stub_browser
      foo = nil
      @site_class.new { |site| foo = site }
      foo.should_not be_nil
      foo.should be_a_kind_of(Taza::Site)
    end
  end
end
