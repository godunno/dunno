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

  it { expect(response.status).to eq 403 }
end

shared_examples_for "incorrect sign in" do

  before(:each) do
    do_action
  end

  it { expect(response.code).to eq "401" }
  it { expect(json["errors"].count).to eq 1 }
end
