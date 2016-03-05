shared_examples :date_format do
  describe "Date format" do
    context "yyyy-mm-dd (ISO8601)" do
      let(:date) { "2016-06-02" }
      it { expect(scrapper.fares.count).to be > 0 }
    end

    context "dd-mm-yyyy" do
      let(:date) { "01-09-2016" }
      it { expect(scrapper.fares.count).to be > 0 }
    end

    context "yyyy/mm/dd" do
      let(:date) { "2016/08/03" }
      it { expect(scrapper.fares.count).to be > 0 }
    end
  end
end
