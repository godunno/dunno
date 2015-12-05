module TrackEvent
  class MediaAccessed
    def initialize(media, profile)
      self.media = media
      self.profile = profile
      self.courses = media.events.map(&:course)
    end

    def track
      assert_is_member
      create_tracking_event
    end

    private

    attr_accessor :media, :profile, :courses

    def event_type
      TrackingEvent.event_types[
        case media.type
        when 'url' then :url_clicked
        when 'file' then :file_downloaded
        end
      ]
    end

    def courses
      @courses.select { |course| profile.has_course?(course) }
    end

    def assert_is_member
      return unless courses.empty?
      fail TrackingEvent::NonMemberError, non_member_error_message
    end

    def non_member_error_message
      "Profile#id #{profile.id} isn't member of any Course#id in #{@courses.map(&:id)}."
    end

    def create_tracking_event
      courses.each do |course|
        TrackingEvent.find_or_create_by!(
          course: course,
          profile: profile,
          event_type: event_type,
          trackable: media
        )
      end
    end
  end
end
