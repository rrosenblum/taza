require 'spec_helper'

describe Taza::ProjectGenerator do
  context "taza create foo_site" do
    context "creates" do

      let(:subject) { Taza::ProjectGenerator.new(['foo_site']) }
      let(:output) { capture(:stdout) { subject.create } }

      it 'a Gemfile' do
        expect(output).to include("Gemfile")
        expect(File.exists?('Gemfile')).to be_true
      end

      it 'a Rakefile' do
        expect(output).to include('Rakefile')
        expect(File.exists?('Rakefile')).to be_true
      end

      it 'the Rakefile can be required' do
        output
        system("ruby -c Rakefile > #{null_device}").should be_true
      end

      it 'config/config.yml' do
        expect(output).to include('config/config.yml')
        expect(File.exists?('config/config.yml')).to be_true
      end

      it 'lib/sites' do
        expect(output).to include('lib/sites')
        expect(File.directory?('lib/sites')).to be_true
      end

      it 'a spec_helper.rb' do
        expect(output).to include('spec/spec_helper.rb')
        expect(File.exists?('spec/spec_helper.rb')).to be_true
      end

      it 'spec_helper.rb can be required' do
        output
        system("ruby -c spec/spec_helper.rb > #{null_device}").should be_true
      end

      it 'spec/isolation' do
        expect(output).to include('spec/isolation')
        expect(File.directory?('spec/isolation')).to be_true
      end

      it 'spec/integration' do
        expect(output).to include('spec/integration')
        expect(File.directory?('spec/integration')).to be_true
      end

      it 'bin' do
        expect(output).to include('bin')
        expect(File.directory?('bin')).to be_true
      end

      it 'the taza executable' do
        expect(output).to include('spec/spec_helper.rb')
        expect(File.exists?('spec/spec_helper.rb')).to be_true
      end
    end
  end


  describe 'old broken tests' do
    xit "should generate a spec helper that can be required" do
      run_generator('taza', [APP_ROOT], generator_sources)
      system("ruby -c #{@spec_helper} > #{null_device}").should be_true
    end

    xit "should generate a rakefile that can be required" do
      run_generator('taza', [APP_ROOT], generator_sources)
      system("ruby -c #{@spec_helper} > #{null_device}").should be_true
    end

    xit "should generate a console script" do
      run_generator('taza', [APP_ROOT], generator_sources)
      File.exists?(File.join(APP_ROOT, 'script', 'console')).should be_true
    end

    xit "should generate a windows console script" do
      run_generator('taza', [APP_ROOT], generator_sources)
      File.exists?(File.join(APP_ROOT, 'script', 'console.cmd')).should be_true
    end
  end
end
