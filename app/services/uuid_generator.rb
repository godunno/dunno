class UuidGenerator
  def initialize(resource)
    @resource = resource
  end

  def generate
    generate_uuid
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
