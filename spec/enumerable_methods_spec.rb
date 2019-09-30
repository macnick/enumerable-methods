# frozen_string_literal: true

require '../enumerable_methods'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:str_to_array) { %w[cat dog wombat] }
  let(:result) { [] }
  describe '#my_each' do
    context 'When passed an array' do
      it 'calls the given block once for each element in self, passing that element as a parameter.' do
        array.my_each { |x| result << x }
        expect(result).to eql([1, 2, 3, 4])
      end
      it 'if no block is given, an Enumerator is returned' do
        expect(array.my_each).to be_a(Enumerator)
      end
      it 'returns an array' do
        expect(array.my_each.to_a).to eq(array)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'When passed an array' do
      it 'returns indexes of elements in array' do
        array.my_each_with_index { |_elem, index| result << index }
        expect(result).to eql([0, 1, 2, 3])
      end

      it 'returns indexes of elements in our array' do
        str_to_array.my_each_with_index { |_el, ind| result << ind }
        expect(result).to eql([0, 1, 2])
      end
    end
  end

  describe '#my_select' do
    context 'When we pass array' do
      it 'returns an array containing all elements of enum for which the given block returns a true value.' do
        expect(array.my_select(&:even?)).to eql([2, 4])
      end
      it 'if no block is given, an Enumerator is returned instead.' do
        expect(array.my_select).to be_a(Enumerator)
      end
    end
  end
  describe '#my_all?' do
    context 'When we pass array' do
      it 'returns true if the block never returns false or nil' do
        expect(str_to_array.my_all? { |word| word.length >= 3 }).to be_truthy
      end
      it 'returns false if the block returns false or nil' do
        expect(str_to_array.my_all? { |word| word.length >= 4 }).to be_falsey
      end
    end
  end
  describe '#my_any?' do
    context 'When we pass array' do
      it 'returns true if the block ever returns a value other than false or nil.' do
        expect(str_to_array.my_any? { |word| word.length >= 3 }).to be_truthy
      end
      it 'returns false if the block returns false or nil' do
        expect(str_to_array.my_any? { |word| word.length >= 4 }).to be_truthy
      end
      it 'if no block given it returns true if one of the collection members is not false/nil.' do
        expect(str_to_array.my_any?).to be_truthy
      end
    end
  end

  describe '#my_none?' do
    context 'When we pass an array' do
      it 'the method returns true if the block never returns true for all elements' do
        expect(str_to_array.my_none? { |word| word.length == 7 }).to be_truthy
      end
      it 'the method returns false if the block returns false for at least one element' do
        expect(str_to_array.my_none? { |word| word.length == 6 }).to be_falsey
      end
      it 'if block is not given, will return true only if none of the collection members is true.' do
        expect(str_to_array.my_none?).to be_falsey
      end
    end
  end

  describe '#my_count' do
    context 'When we pass an array' do
      it 'returns the number of items in enum through enumeration' do
        expect(array.my_count).to eql(4)
      end
      it 'If an argument is given, the number of items in enum that are equal to item are counted' do
        expect(array.my_count(2)).to eql(1)
      end
      it 'If a block is given, it counts the number of elements yielding a true value.' do
        expect(array.my_count(&:even?)).to eql(2)
      end
    end
  end

  describe '#my_map' do
    context 'When we pass a running bock' do
      it 'Returns a new array with the results of running block once for every element in enum.' do
        expect(array.my_map { |i| i * i }).to eq([1, 4, 9, 16])
      end
      it 'if no block is given, an enumerator is returned instead.' do
        expect(array.my_map).to be_a(Enumerator)
      end
    end
  end

  describe '#my_inject' do
    context 'If you pass a block, then for each el in enum the block is passed an accumulator value and the el' do
      it 'it returns all elements combined by the specified operation' do
        expect(array.my_inject(5, :+)).to eql(15)
      end
      it 'it returns all elements combined by the specified operation' do
        expect(array.my_inject(5) { |product, n| product * n }).to eql(120)
      end
    end
    context 'f you do not explicitly specify an initial value for memo,' do
      it ' the first element of collection is used as the initial value of memo' do
        expect(array.my_inject { |product, n| product * n }).to eql(24)
      end
      it 'it returns all elements combined by the specified operation' do
        expect(array.my_inject(:+)).to eql(10)
      end
    end
  end
end
