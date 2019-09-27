# frozen_string_literal: true

require '../enumerable_methods'

RSpec.describe Enumerable do
 describe 'my_each' do
    context 'When passed an array' do
      it 'calls the given block once for each element in self, passing that element as a parameter.' do
        arr = %w[a b c]
        expect(arr.each { |x| print x, ' -- ' }).to eql('a -- b -- c --')
        expect(arr.each).to eql(0...3)
      end
    end
  end
  describe '#my_each_with_index' do
    let(:array) { [1, 2, 3, 4] }
    let(:str_to_array) { %w[cat dog wombat] }
    let(:result) { [] }
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
