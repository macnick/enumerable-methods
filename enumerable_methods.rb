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
    for i in 0...self.length
        yield self[i], i
      end
    end
  end

  def my_select
    result = []
    self.my_each {|e| 
      result << e if yield(e)
    }
    result
  end

  def my_all?

  end

  def my_any?
  
  end

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