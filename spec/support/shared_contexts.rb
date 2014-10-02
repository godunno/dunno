shared_examples_for "API authentication required" do

  context "when not authenticated" do

    pending "Authentication not implemented yet."
  end
end

shared_examples_for "Dashboard authentication required" do

  context "when not authenticated" do

    pending "Authentication not implemented yet."
  end
end

shared_examples_for "request invalid content type XML" do

  it do
    expect { do_action }.to raise_error(ActionController::UnknownFormat)
  end
end

shared_examples_for "closed event" do

  before(:each) do
    event.close!
    do_action
  end

  it { expect(last_response.status).to eq(403) }
end

shared_examples_for "incorrect sign in" do

  context "via API" do
    before(:each) do
      do_action
    end

    it { expect(last_response.status).to eq(401) }
    it { expect(json["errors"].count).to eq 1 }
  end

  context "via browser" do
    before do
      Warden.test_mode!
      logout(:user)
      get "/dashboard/#{profile}", format: 'html'
    end
    after { Warden.test_reset! }

    it { expect(last_response.status).to eq(302) }
    it { expect(last_response.location).to match(%r{/sign_in$}) }
  end
end

shared_examples_for "request return check" do |attributes|
  attributes.each do |attribute|
    describe "##{attribute}" do
      it "should have the same value for #{attribute}" do
        value = target.send(attribute)
        value = case value
                when Time then value.utc.iso8601
                when Date then value.to_json.gsub('"', '')
                else value
                end
        expect(subject[attribute.to_s]).to eq value
      end
    end
  end
end

shared_examples_for "creating an artifact" do
  it { expect(subject.teacher).to eq teacher }
  it { expect(subject.event).to eq event }
end
