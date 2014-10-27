require 'spec_helper'

describe Artifact do

  describe "associations" do
    it { is_expected.to belong_to(:timeline) }
  end

  it_behaves_like "artifact common examples"

end
