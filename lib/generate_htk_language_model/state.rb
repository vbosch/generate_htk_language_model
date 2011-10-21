module GenerateHtkLanguageModel
  require 'ap'
  class State
    attr_reader :id, :label, :type, :transitions
    def initialize(ex_id, ex_label,ex_type = :NORMAL)
     @id = ex_id
     @label = ex_label
     @type = ex_type
     @transitions = Hash.new
    end

    def label_sym
      return [@type,@label.upcase.to_sym] if @type == :NORMAL or @type == :START
      [@label.upcase.to_sym,@type]
    end

    def to_s
      "#{@id}: #{@label}"
    end

    def set_statistics(statistics_hash)
      @current_statistics = statistics_hash
    end

    def recalculate_probabilities
      ap label_sym
      prior_count = child_count
      @transitions.each_value do |val|

        if prior_count == 0.0
          val[:probability] = 0.0
        elsif val[:to].label == "!NULL"
          val[:probability] =  Math.log(val[:to].child_count/prior_count,Math::E)
        else
          val[:probability] = Math.log(@current_statistics[val[:to].label_sym]/prior_count,Math::E)
        end
      end
    end

    def child_count
      count = 0.0
      @transitions.each_value{|val| count += val[:to].label == "!NULL" ? val[:to].child_count : @current_statistics[val[:to].label_sym]}
      count
    end

    def add_transition(state,probability)
      @transitions[state.id]={:to => state, :probability => probability}
    end
  end
end