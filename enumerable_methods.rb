module Enumerable

    def my_each
        if block_given?
            for i in 0...self.length
            yield self[i]
            end
        else
            to_enum(:my_each)
        end
    end
  
    def my_each_with_index
        if block_given?
          self.my_each { |e, i = 0|
              yield self[i], i
              i+=1
          }
        else
          to_enum(:my_each_with_index)
        end
      end

      def my_select
        if block_given?
          result = []
          self.my_each {|e| 
            result << e if yield(e)
          }
          result
        else
          to_enum(:my_select)
        end
      end

      def my_all?
        if block_given?
          my_each { |e| return false unless yield e }
        else
          return my_all? {|e| e }
        end
        true
      end

      def my_any?
        if block_given?
          my_each { |e| return true if yield e }
        else
          return my_any? {|e| e }
        end
        false
      end
  # methods below this line are not ready yet 
    

  def my_none?
  end

  def my_count
  end

  def my_map
  end

  def my_inject
  end

  def multiply_els
  end

end