module GenerateHtkLanguageModel
  require 'ap'
  class SampleStatistics
    attr_reader :statistics
    def initialize(ex_name)
      @name= ex_name
      @last_read=:START
      @statistics = Hash.new{0.0}
    end

    def set_tag_filter(&block)
      @tag_filter = block
    end

    def set_line_reader(&block)
      @line_reader = block
    end

    def push_line(line)
      line_type = @line_reader.call(line)
      unless @tag_filter.call(line_type)

        @statistics[[@last_read,line_type]]+=1.0

        @statistics[[:NORMAL,line_type]]+=1.0 if line_type != :END and @last_read != :START
        @statistics[:COUNT]+=1.0 if line_type != :END
        @statistics[[:NORMAL,@last_read]]-=1.0 if line_type == :END
        @last_read=line_type
      end
    end

    def write(file_name)
      File.open(file_name,"w") do |file|

      end
    end


  end
end