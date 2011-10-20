module AssesLineDetectionAccuracy
  require 'ap'
  class SampleDefinition
    def initialize(ex_name)
      @name= ex_name
      @lines = Array.new
    end

    def set_tag_filter(&block)
      @tag_filter = block
    end

    def set_line_reader(&block)
      @line_reader = block
    end

    def push_line(line)
      tmp = @line_reader.call(line)
      @lines.push(tmp) unless @tag_filter.call(tmp)
    end

    def write(file_name)
      File.open(file_name,"w") do |file|
        file.puts "# File: #{@name}"
        file.puts "# Resl: ? ?"
        file.puts " ##############################"
        file.puts "# Line n:  start     end    #"
        file.puts " ##############################"

        @lines.each_with_index do |val,index|
          file.puts "Line #{index+1}: #{val[:start]} #{val[:end]}"
        end
      end
    end


  end
end