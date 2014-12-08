module IndexedModels
  MODELS = [Media]

  def refresh_index!
    MODELS.each do |model|
      model.import
      model.__elasticsearch__.refresh_index!
    end
  end

  def self.create_index!
    MODELS.each do |model|
      model.__elasticsearch__.create_index! index: model.index_name
    end
  end

  def self.delete_index!
    MODELS.each do |model|
      model.__elasticsearch__.client.indices.delete index: model.index_name
    end
  end
end

RSpec.configure do |config|
  config.include IndexedModels, elasticsearch: true

  config.before(:each, elasticsearch: true) do
    IndexedModels.create_index!
  end

  config.after(:each, elasticsearch: true) do
    IndexedModels.delete_index!
  end
end
