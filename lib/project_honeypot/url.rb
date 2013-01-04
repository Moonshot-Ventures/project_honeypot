module ProjectHoneypot
  class Url
    SEARCH_ENGINES = %w(
      Undocumented
      AltaVista
      Ask
      Baidu
      Excite
      Google
      Looksmart
      Lycos
      MSN
      Yahoo
      Cuil
      InfoSeek
      Miscellaneous
    )

    attr_reader :ip_address, :last_activity, :score, :offenses, :search_engine
    def initialize(ip_address, honeypot_response)
      @ip_address = ip_address
      @safe = honeypot_response.nil?
      process_score(honeypot_response)
    end

    def safe?(hash = {})
      score = hash[:score] || ProjectHoneypot.score
      last_activity = hash[:last_activity] || ProjectHoneypot.last_activity

      forbidden_offenses = hash[:offenses] ||
                            ProjectHoneypot.offenses ||
                            [:comment_spammer, :harvester, :suspicious]

      detected_offenses = forbidden_offenses & @offenses

      @safe ||
        detected_offenses.length == 0 ||
        !(
          last_activity.nil? && score.nil? ||
          !score.nil? && self.score >= score ||
          !last_activity.nil? && self.last_activity >= last_activity
        )
    end

    def search_engine?
      @offenses.include?(:search_engine)
    end

    def comment_spammer?
      @offenses.include?(:comment_spammer)
    end

    def harvester?
      @offenses.include?(:harvester)
    end

    def suspicious?
      @offenses.include?(:suspicious)
    end

    private

    def process_score(honeypot_response)
      if honeypot_response.nil?
        @last_activity = nil
        @score = 0
        @offenses = []
      else
        hp_array = honeypot_response.split(".")

        if hp_array[3].to_i == 0
          # search engine
          @last_activity = nil
          @score = 0
          @offenses = [:search_engine]
          @search_engine = (hp_array[2].to_i < SEARCH_ENGINES.length ?
                            SEARCH_ENGINES[hp_array[2].to_i] :
                            SEARCH_ENGINES[0])
        else
          @last_activity = hp_array[1].to_i
          @score = hp_array[2].to_i
          @offenses = set_offenses(hp_array[3])
        end
      end
    end

    def set_offenses(offense_code)
      offense_code = offense_code.to_i
      offenses = []
      offenses << :comment_spammer if offense_code/4 == 1
      offense_code = offense_code % 4
      offenses << :harvester if offense_code/2 == 1
      offense_code = offense_code % 2
      offenses << :suspicious if offense_code == 1
      offenses
    end
  end
end
