# frozen_string_literal: true

require '../enumerable_methods'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:str_to_array) { %w[cat dog wombat] }
  let(:result) { [] }
  describe 'my_each' do
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
      it 'If no block is given, an Enumerator is returned instead.' do
        expect(array.my_select).to be_a(Enumerator)
      end
    end
  end
end
