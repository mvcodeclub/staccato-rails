module Staccato
  module SessionTracking

    def global_context
      {}
    end

    def hit_context
      {}
    end

    def staccato_tracker
      @staccato_tracker ||= Staccato.tracker(staccato_tracker_id, staccato_client_id, global_context)
    end

    # pull tracker id from config
    def staccato_tracker_id
      Rails.configuration.staccato.tracker_id
    end

    # load or set new uuid in session
    def staccato_client_id
      session['staccato.client_id'] ||= Staccato.build_client_id
    end

    # This is called in an `ensure` block by actionpack
    #   errors raised here _may_ be particularly dangerous
    def append_info_to_payload(payload)
      super

      payload["staccato.tracker"] = staccato_tracker
      payload["staccato.context"] = hit_context
    end
  end
end
