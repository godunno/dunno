shared_examples_for "incorrect sign in" do
  before(:each) do
    do_action
  end

  it { expect(last_response.status).to eq(401) }
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
