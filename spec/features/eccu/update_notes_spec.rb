require 'spec_helper'

describe "Given I want to update the notes of a request" do
  subject { AkamaiApi::ECCURequest.new code: '1234' }

  context "when login credentials are invalid", vcr: { cassette_name: "akamai_api_eccu_update_notes/invalid_credentials" } do
    before do
      allow(AkamaiApi).to receive(:config) { { auth: ['foo', 'bar'] } }
      allow(AkamaiApi::ECCU).to receive(:client) { AkamaiApi::ECCU.send(:build_client) }
    end

    it "raises Unauthorized" do
      expect { subject.update_notes! 'request updated using AkamaiApi' }.to raise_error AkamaiApi::Unauthorized
    end
  end

  context "when request id cannot be found", vcr: { cassette_name: "akamai_api_eccu_update_notes/not_found_request" } do
    it "raises NotFound" do
      expect { subject.update_notes! 'request updated using AkamaiApi' }.to raise_error AkamaiApi::ECCU::NotFound
    end
  end

  context "when request id is found", vcr: { cassette_name: "akamai_api_eccu_update_notes/successful" } do
    it "returns true" do
      expect(subject.update_notes! 'request updated using AkamaiApi').to be_truthy
    end
  end
end
