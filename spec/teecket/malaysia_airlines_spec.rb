require "spec_helper"

describe MalaysiaAirlines, vcr: true do

  let(:from) { "KUL" }
  let(:to)   { "KCH" }
  let(:scrapper) { described_class.new(from: from, to: to, date: "2015-11-10") }

  before do
    scrapper.search
  end

  context "Correct from & to format" do
    it { expect(scrapper.fares.count).to be > 0 }
  end

  context "Incorrect from &/or format" do
    let(:from) { "Kuala Lumpur" }
    it { expect(scrapper.fares).to eql([]) }
  end

end
