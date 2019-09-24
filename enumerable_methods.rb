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
      i = 0
      my_each do |e|
        yield(e, i)
        i += 1
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
end

def multiply_els(arr)
  arr.my_inject(:*)
end
