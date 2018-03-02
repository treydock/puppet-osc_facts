require 'spec_helper'

describe 'cpu_codename Fact' do
  context 'Broadwell nodes' do
    before :each do
      Facter.clear
      Facter.stubs(:value).with(:processor0).returns('Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz')
    end

    it "should return broadwell" do
      expect(Facter.fact(:cpu_codename).value).to eq("broadwell")
    end
  end

  context 'Haswell nodes' do
    before :each do
      Facter.clear
      Facter.stubs(:value).with(:processor0).returns('Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz')
    end

    it "should return haswell" do
      expect(Facter.fact(:cpu_codename).value).to eq("haswell")
    end
  end

  context 'unknown CPU' do
    before(:each) do
      Facter.clear
      Facter.stubs(:value).with(:processor0).returns('something unknown')
    end

    it 'should be nil' do
      expect(Facter.fact(:cpu_codename).value).to be_nil
    end
  end
end
