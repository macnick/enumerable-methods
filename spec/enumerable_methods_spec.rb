# frozen_string_literal: true
require '../enumerable_methods'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:str_to_array) { %w[cat dog wombat] }
  let(:result) { [] }
  describe '#my_each' do
      context 'When passed an array' do
        it 'calls the given block once for each element in self, passing that element as a parameter.' do
          array.my_each { |x| result << x}
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
        array.my_each_with_index { |elem, index| result << index }
        expect(result).to eql([0, 1, 2, 3])
      end

      it 'returns indexes of elements in our array' do
        str_to_array.my_each_with_index { |el, ind| result << ind }
        expect(result).to eql([0, 1, 2])
      end
    end
  end

  describe '#my_select' do
    context 'When we pass array' do
      it 'returns an array containing all elements of enum for which the given block returns a true value.' do
      expect(array.my_select { |num| num.even? }).to eql([2, 4])
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
    it 'if the block is not given, Ruby adds an implicit block of { |obj| obj } that will return true if at least one of the collection members is not false or nil.' do
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
end
