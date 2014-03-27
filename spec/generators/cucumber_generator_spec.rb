require 'spec_helper'

describe Taza::CucumberGenerator do

  before(:each) do
    capture(:stdout) { Taza::SiteGenerator.new(['foo_site']).site }
  end

  context "taza cucumber foo_site" do
    context "creates" do

      let(:subject) { Taza::CucumberGenerator.new(['foo_site']) }
      let(:output) { capture(:stdout) { subject.cucumber  }}

      it 'features/' do
        expect(output).to include('features')
        expect(File.directory?('features')).to be_true
      end

      it 'features/example.feature' do
        expect(output).to include('features/example.feature')
        expect(File.exists?('features/example.feature')).to be_true
      end

      it 'features/support' do
        expect(output).to include('features/support')
        expect(File.directory?('features/support')).to be_true
      end

      it 'features/support/env.rb' do
        expect(output).to include('features/support/env.rb')
        expect(File.exists?('features/support/env.rb')).to be_true
      end

      it 'features/support/hooks.rb' do
        expect(output).to include('features/support/hooks.rb')
        expect(File.exists?('features/support/hooks.rb')).to be_true
      end

      it 'features/step_definitions' do
        expect(output).to include('features/step_definitions')
        expect(File.directory?('features/step_definitions')).to be_true
      end

      it 'features/support/hooks.rb' do
        expect(output).to include('features/step_definitions/example_steps.rb')
        expect(File.exists?('features/step_definitions/example_steps.rb')).to be_true
      end

      it 'gives message if site does not exist' do
        bar_page = capture(:stdout) { Taza::CucumberGenerator.new(['bar_site']).cucumber }
        expect(bar_page).to include("No such site bar_site exists")
      end

      #it 'generates a page that can be required' do
      #  output
      #  page_spec = 'spec/isolation/home_page_spec.rb'
      #  expect(system("ruby -c #{page_spec} > #{null_device}")).to be_true
      #end
    end
  end
end
