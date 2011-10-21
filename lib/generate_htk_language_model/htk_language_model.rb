module GenerateHtkLanguageModel
  require 'graphviz'
  class HTKLanguageModel
    def initialize
      @states = Array.new
      @transitions = 0
    end

    def number_of_states
      @states.size
    end

    def number_of_transitions
      @transitions
    end

    def add_state(ex_label,ex_type=:NORMAL)
      @states.push(State.new(@states.size, ex_label,ex_type))
    end

    def add_transition(id_from,id_to,probability=0.0)
      if is_valid_state_id? id_from and is_valid_state_id? id_to  and is_valid_probability? probability
        @transitions+=1
        @states[id_from].add_transition(@states[id_to],probability)
      end
    end

    def recalculate_probabilities_from_statistics(statistics_hash)
      @states.each{|state| state.set_statistics(statistics_hash)}
      @states.each{|state| state.recalculate_probabilities}
    end

    def is_valid_state_id?(ex_id)
      ex_id >= 0 and ex_id < @states.size
    end

    def is_valid_probability?(prob)
      prob <= 0
    end

    def write(ex_file_name)
      File.open(ex_file_name,"w") do |file|
        file.puts "VERSION=1.0"
        file.puts "N=#{@states.size} L=#{@transitions}"
        @states.each{|state| file.puts "I=#{state.id} W=#{state.label}"}
        seen_transitions = 0
        @states.each do |state|
          state.transitions.each do |key,val|
            file.puts "J=#{seen_transitions} S=#{state.id} E=#{key} l=#{val[:probability]}"
            seen_transitions+=1
          end
        end
      end
    end

    def draw(ex_file_name)
      diagram = GraphViz::new("structs", "type" => "digraph")
      diagram[:rankdir] = "LR"
      diagram.node[:color] = "#ddaa66"
      diagram.node[:style] = "filled"
      diagram.node[:shape] = "circle"
      diagram.node[:penwidth] = "1"
      diagram.node[:fontname] = "Arial"
      diagram.node[:fontsize] = "8"
      diagram.node[:fillcolor]= "#ffeecc"
      diagram.node[:fontcolor]= "#775500"
      diagram.node[:margin] = "0.0"


      @states.each { |state| diagram.add_node(state.to_s) }
      @states.each do |state|
        state.transitions.each do |key, val|
          diagram.add_edge(state.to_s, val[:to].to_s, :label => val[:probability].round(5).to_s)
        end
      end

      diagram.output(:png => "#{ex_file_name}")


    end
  end
end