module IndexedModels
  MODELS = [Media]

  def refresh_index!
    before do
      MODELS.each do |model|
        model.import
        model.__elasticsearch__.refresh_index!
      end
    end
  end
end

RSpec.configure do |config|
  config.extend IndexedModels, elasticsearch: true

  config.before(:each, elasticsearch: true) do
    IndexedModels::MODELS.each do |model|
      model.__elasticsearch__.create_index! index: model.index_name
    end
  end

  config.after(:each, elasticsearch: true) do
    IndexedModels::MODELS.each do |model|
      model.__elasticsearch__.client.indices.delete index: model.index_name
    end
  end
end
