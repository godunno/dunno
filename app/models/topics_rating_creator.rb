class TopicsRatingCreator

  def initialize(topics_params)
    @topics_params = topics_params
  end

  def create
    Topic.transaction do
      build_and_save.all?
    end
  end

  private

    def build_and_save
      @topics_params.each do |t|
        topic = Topic.where(id: t[:id]).first!
        topic.ratings.build(t[:ratings_attributes])
        topic.save!
      end
    end
end