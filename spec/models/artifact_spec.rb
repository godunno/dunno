require 'spec_helper'

describe Artifact do

  describe "associations" do
    it { should belong_to(:timeline) }
  end

  shared_examples_for "artifact common examples" do
    it { should respond_to(:teacher) }
    it { should respond_to(:event) }
  end

  it_behaves_like "artifact common examples"

  shared_examples_for "artifact" do
    describe "associations" do
      it { should have_one(:predecessor) }
    end

    describe "inheritance" do
      it_behaves_like "artifact common examples"
    end
  end
end
