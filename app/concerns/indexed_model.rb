module IndexedModel
  extend ActiveSupport::Concern

  included do
    index_name [Rails.env, model_name.collection].join('_')

    after_commit :__update_index__, on: [:create, :update]
    after_commit :__delete_index__, on: [:destroy]
  end

  private

  def __update_index__
    __run_index__(:index)
  end

  def __delete_index__
    __run_index__(:delete)
  end

  def __run_index__(operation)
    IndexerWorker.perform_async(self.class.name, operation, id)
  end
end
