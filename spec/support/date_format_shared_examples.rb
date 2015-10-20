shared_examples :date_format do

  describe "Date format" do
    context "yy-mm-dd" do
      let(:date) { "15-11-10" }
      it { expect(scrapper.fares.count).to be > 0 }
    end

    context "yyyy-mm-dd (ISO8601)" do
      let(:date) { "2015-11-10" }
      it { expect(scrapper.fares.count).to be > 0 }
    end

    context "dd-mm-yyyy" do
      let(:date) { "10-11-2015" }
      it { expect(scrapper.fares.count).to be > 0 }
    end

    context "yyyy/mm/dd" do
      let(:date) { "2015/11/19" }
      it { expect(scrapper.fares.count).to be > 0 }
    end
  end

end
