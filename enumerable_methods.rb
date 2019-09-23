# frozen_string_literal: true

module Enumerable
  def my_each
    if block_given?
      (0...length).each do |i|
        yield self[i]
      end
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      my_each do |_e, i = 0|
        yield(self[i], i)
      end
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    if block_given?
      result = []
      my_each do |e|
        result << e if yield(e)
      end
      result
    else
      to_enum(:my_select)
    end
  end

  def my_all?(pattern = nil)
    unless pattern.nil?
      return false if instance_of?(Hash)

      return my_all? { |e| pattern.match(e) }
    end

    return my_all? { |e| e } unless block_given?

    my_each { |e| return false unless yield(e) }
    true
  end

  def my_any?(pattern = nil)
    unless pattern.nil?
      return false if instance_of?(Hash)

      return my_any? { |e| pattern.match(e) }
    end

    return my_any? { |e| e } unless block_given?

    my_each { |e| return true if yield(e) }
    false
  end

  def my_none?(*pattern)
    return !my_any?(*pattern) unless block_given?

    !my_any? { |e| yield(e) }
  end

  def my_count(arg = nil)
    return my_select { |e| yield e }.size if block_given? && arg.nil?
    return my_select { |e| e == arg }.size if arg && !block_given?

    size
  end

  def my_map(proc = nil)
    result = []
    if block_given?
      my_each do |e|
        result << yield(e)
      end
      result
    elsif proc
      my_each do |e|
        result << proc.call(e)
      end
      result
    else
      to_enum(:my_map)
    end
  end

  def my_inject(stv = nil, sym = nil)
    # make sure it can take custom stv (starting value) and symbol procs like :+
    return my_inject(nil, stv) if stv.is_a? Symbol

    return my_inject(stv) { |mem, e| :+.to_proc.call(mem, e) } unless sym.nil?

    my_each { |e| stv = stv.nil? ? first : yield(stv, e) }
    stv
  end

  # def my_inject(stv = nil, sym = nil, &block)
  #   # with checks it can handle everything
  #   stv = stv.to_sym if stv.is_a?(String) && !sym && !block
  #   if stv.is_a?(Symbol) && !sym
  #     block = stv.to_proc
  #     stv = nil
  #   end
  #   sym = sym.to_sym if sym.is_a?(String)
  #   block = sym.to_proc if sym.is_a?(Symbol)

  #   # Ready to rock & roll
  #   each { |x| stv = stv.nil? ? x : block.yield(stv, x) }
  #   stv
  # end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

# TESTS

# my_proc = proc { |x| x**2 }

# p [10, 18, 4, 6, 4, 16, 5].my_map(&my_proc)
# p [10, 18, 4, 6, 4, 16, 5].map(&my_proc)

# p multiply_els([2,4,5])

# p [1, 2, 3, 4, 5].reduce(2,&:+)
# p [1, 2, 3, 4, 5].my_inject(2,&:+)
# p [1, 2, 3, 4, 5].my_inject(&:*)
# p [1, 2, 3, 4, 5].my_inject(2, &:*)
# p %w(3 4 5).my_inject(&:+)
# p %w(3 4 5).my_inject("hello", &:+)

# p ([1, 2, 3, 4, 5]).my_inject { |sum, n| sum * n }
# p [1, 2, 3, 4, 5].inject { |sum, n| sum * n }

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
# p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# p %w{ant bear cat}.my_none?(/d/)                        #=> true
# p [].my_none?                                           #=> true
# p [nil].my_none?                                        #=> true
# p [nil, false].my_none?                                 #=> true
# p [nil, false, true].my_none?  # false
# p [10, 18, 4, 6, 14, 16, 5, 8].any? { |e| e == 17 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_any? { |e| e == 17 }
# p "without block"
# p [nil, nil].any?
# p [nil, nil].my_any?
# p "with regex"
# p %w[ant bear cat].any?(/d/)
# p %w[ant bear cat].my_any?(/d/)
# p [nil, true, 99].any?
# p [nil, true, 99].my_any?

# p [10, 18, 4, 6, 14, 16, 5, 8].all? { |e| e >= 0 }
# p [10, 18, 4, 6, 14, 16, 5, 8].my_all? { |e| e >= 0 }
# p 'without block'
# p [10, 18, 4, 6, 14, 16, nil, 8].all?
# p [10, 18, 4, 6, 14, 16, nil, 8].my_all?

# p %w[ant bear cat].all?(/t/)
# p %w[ant bear cat].my_all?(/t/)
# p [nil, true, 99].all?
# p [nil, true, 99].my_all?
# p [].all?
# p [].my_all?
# hash = Hash.new
# %w(cat dog wombat).each_with_index { |item, index|
#   hash[item] = index
# }
# p hash
# %w(cat dog wombat).my_each_with_index { |item, index|
#   hash[item] = index
# }
# p hash
# p %w(cat dog wombat).each_with_index
# p %w(cat dog wombat).my_each_with_index
