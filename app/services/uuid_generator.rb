class UuidGenerator

  def initialize(resource)
    @resource = resource
  end

  def generate!
    @resource.uuid = generate_uuid
    @resource.save!
  end

  private
    def generate_uuid
      loop do
        uuid = SecureRandom.uuid
        break uuid unless uuid_exists?(uuid)
      end
    end

    def uuid_exists?(uuid)
      @resource.class.where(uuid: uuid).any?
    end
end