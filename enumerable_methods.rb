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

      def my_none?(*pattern)
        if block_given?
          return !my_any? { |e| yield e }
        else
          return !my_any?(*pattern)
        end
      end

      def my_count(arg = nil)
        if block_given? && arg.nil?
          return my_select {|e| yield e}.size
        elsif arg && !block_given?
          return my_select {|e| e == arg}.size
        end
        self.size
      end

      def my_map(proc = nil)
        result = []
        if block_given?
            my_each {|e| 
              result << yield(e)
            }
          result
        elsif proc
          my_each {|e| 
           result << proc.call(e)
          }
          result
        else
            to_enum(:my_map)
        end
      end

      def my_inject(sv = nil, sym = nil, &block)
        # with checks it can handle everything
        sv = sv.to_sym if sv.is_a?(String) && !sym && !block
        block, sv = sv.to_proc, nil if sv.is_a?(Symbol) && !sym
        sym = sym.to_sym if sym.is_a?(String)
        block = sym.to_proc if sym.is_a?(Symbol)
    
        # Ready to rock & roll
        each { |x| sv = sv.nil? ? x : block.yield(sv, x) }
        sv
      end

end

def multiply_els(arr)
  arr.my_inject(:*)
end

# TESTS

# my_proc = proc { |x| x**2 }

# p [10, 18, 4, 6, 4, 16, 5].my_map(&my_proc)
# p [10, 18, 4, 6, 4, 16, 5].map(&my_proc)

# p multiply_els([2,4,5])

# p [1,2,3,4,5].reduce(2,&:+) 
# p [1,2,3,4,5].my_inject(2,&:+) 
# p [1,2,3,4,5].my_inject(:*)  
# p [1,2,3,4,5].my_inject(2, &:*)   
# p %w(3 4 5).my_inject(&:+)  
# p %w(3 4 5).my_inject("hello", &:+) 

# p [1,2,3,4,5].my_inject { |sum, n| sum * n }
# p [1,2,3,4,5].inject { |sum, n| sum * n }

# p [10, 18, 4, 6, 4, 16, 5].map {|e| e * 2}
# p [10, 18, 4, 6, 4, 16, 5].my_map {|e| e * 2}
# p [10, 18, 4, 6, 4, 16, 5].map
# p [10, 18, 4, 6, 4, 16, 5].my_map
 
# p [10, 18, 4, 6, 4, 16, 5, 8].count 
# p [10, 18, 4, 6, 4, 16, 5, 8].my_count
  
# p [10, 18, 4, 6, 4, 16, 5, 8].count(1)
# p [10, 18, 4, 6, 4, 16, 5, 8].my_count(1)

# p [10, 18, 4, 6, 14, 16, 5, 8].count { |x| x%2==0 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_count { |x| x%2==0 }

# p [10, 18, 4, 6, 14, 16, 5, 8].none? { |e| e < 0 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_none? { |e| e < 0 }
# p "without block"
# p [nil, nil, nil].none? 
# p [nil, nil, nil].my_none? 
# p [nil, nil, 5].none? 
# p [nil, nil, 5].my_none? 

# p [10, 18, 4, 6, 14, 16, 5, 8].any? { |e| e == 17 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_any? { |e| e == 17 }
# p "without block"
# p [nil, nil].any? 
# p [nil, nil].my_any?  

# p [10, 18, 4, 6, 14, 16, 5, 8].all? { |e| e >= 0 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_all? { |e| e >= 0 }
# p "without block"
# p [10, 18, 4, 6, 14, 16, nil, 8].all? 
# p [10, 18, 4, 6, 14, 16, nil, 8].my_all? 
