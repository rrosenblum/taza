require 'spec_helper'

describe Taza::PartialGenerator do

  before(:each) do
    capture(:stdout) { Taza::SiteGenerator.new(['foo_site']).site }
  end

  context "taza partial navigation foo_site" do
    context "creates" do

    let(:subject) { Taza::PartialGenerator.new(['navigation', 'foo_site']) }
    let(:output) { capture(:stdout) { subject.partial } }

    it 'a navigation.rb' do
      expect(output).to include('lib/sites/foo_site/pages/partials/navigation.rb')
      expect(File.exists?('lib/sites/foo_site/pages/partials/navigation.rb')).to be_true
    end

    it 'message if site does not exist' do
      bar_page = capture(:stdout) { Taza::PartialGenerator.new(['navigation', 'bar_site']).partial }
      expect(bar_page).to include("No such site bar_site exists")
    end
      end
  end
  context 'failing specs' do
    xit "should give you usage if you do not give two arguments" do
      PartialGenerator.any_instance.expects(:usage)
      lambda { run_generator('partial', [@partial_name], generator_sources) }.should raise_error
    end

    xit "should give you usage if you give a site that does not exist" do
      PartialGenerator.any_instance.expects(:usage)
      $stderr.expects(:puts).with(regexp_matches(/NoSuchSite/))
      lambda { run_generator('partial', [@partial_name, "NoSuchSite"], generator_sources) }.should raise_error
    end
  end
end
