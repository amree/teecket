require "spec_helper"

describe Firefly, vcr: true do

  let(:from) { "SZB" }
  let(:to)   { "AOR" }
  let(:scrapper) { described_class.new(from: from, to: to, date: "10-11-15") }

  before do
    scrapper.search
  end

  context "Correct from & to format" do
    it { expect(scrapper.fares.count).to be > 0 }
  end

  context "Incorrect from &/or format" do
    let(:from) { "ABC" }
    it { expect(scrapper.fares).to eql([]) }
  end

end
