require 'spec_helper'

describe HasUuid do
  class ModelWithUuid
    extend ActiveModel::Callbacks
    define_model_callbacks :create
    include HasUuid
    attr_accessor :uuid
    def save!
      run_callbacks :create do; end
    end
    def self.where(*_args)
      []
    end
  end

  let(:model) { ModelWithUuid.new }

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new model with uuid" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            model.save!
          end.to change{model.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end
