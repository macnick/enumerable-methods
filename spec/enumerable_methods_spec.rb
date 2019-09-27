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
end
