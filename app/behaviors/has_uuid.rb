module HasUuid
  extend ActiveSupport::Concern

  included do
    before_create :set_uuid
  end

  private

    def set_uuid
      self.uuid = UuidGenerator.new(self).generate
    end
end
