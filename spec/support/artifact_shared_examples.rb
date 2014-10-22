shared_examples_for "artifact common examples" do
  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:event) }
end

shared_examples_for "artifact" do
  describe "associations" do
    it { is_expected.to have_one(:predecessor) }
  end

  describe "inheritance" do
    it_behaves_like "artifact common examples"
  end
end
