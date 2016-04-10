require 'rails_helper'

describe BrazilianPhone do

  let(:list_of_phones) {[
    "+55 (081) 99824-0131",
    "55 (081) 99824-0131",
    "55081998240131",
    "+055 (081) 99824-0131",
    "055 (081) 99824-0131",
    "055081998240131",
    "+55 (81) 99824-0131",
    "55 (81) 99824-0131",
    "5581998240131",
    "+055 (81) 99824-0131",
    "055 (81) 99824-0131",
    "05581998240131"
    ]}

  let(:expect_format_response) {
    { country_code: "55", region_code: "81", number: "998240131" }
  }

  let(:expect_normalize_response1) { "55081998240131" }
  let(:expect_normalize_response2) { "055081998240131" }
  let(:expect_normalize_response3) { "5581998240131" }
  let(:expect_normalize_response4) { "05581998240131" }

  subject { BrazilianPhone }

  context ".format" do
    it { expect(subject).to respond_to(:format).with(1).argument }
    it { expect(subject).not_to respond_to(:format).with(0).argument }
    it { expect(subject).not_to respond_to(:format).with(2).argument }
    it { list_of_phones.each {|phone| expect(subject.format(phone)).to eq(expect_format_response)} }
  end

  context ".normalize" do
    it { expect(subject).to respond_to(:normalize).with(1).argument }
    it { expect(subject).not_to respond_to(:normalize).with(0).argument }
    it { expect(subject).not_to respond_to(:normalize).with(2).argument }
    it { list_of_phones[0..2].each  {|phone| expect(subject.normalize(phone)).to eq(expect_normalize_response1)} }
    it { list_of_phones[3..5].each  {|phone| expect(subject.normalize(phone)).to eq(expect_normalize_response2)} }
    it { list_of_phones[6..8].each  {|phone| expect(subject.normalize(phone)).to eq(expect_normalize_response3)} }
    it { list_of_phones[9..11].each {|phone| expect(subject.normalize(phone)).to eq(expect_normalize_response4)} }
  end

end