require 'app/services/dijkstra_algorithm_service'

RSpec.describe DijkstraAlgorithmService, type: :class do
  subject(:service) { described_class.instance }

  let(:start_node) { 0 }
  let(:stop_node) { 1 }

  describe '#call' do
    context 'when input is invalid' do
      context 'when input matrix is nil' do
        let(:matrix) { nil }

        it 'returns 0' do
          expect(service.call(matrix, start_node, stop_node)).to eq 0
        end
      end

      context 'when input matrix is empty' do
        let(:matrix) { [] }

        it 'returns 0' do
          expect(service.call(matrix, start_node, stop_node)).to eq 0
        end
      end

      context 'when input matrix is not square' do
        let(:matrix) do
          [
            [1, 2, 3],
            [4, 5, 6]
          ]
        end

        it 'returns 0' do
          expect { service.call(matrix, start_node, stop_node) }.to raise_error MatrixNotSquareError
        end
      end
    end

    context 'when input is valid' do
      let(:matrix) do
        [
          [0, 0, 1, 3, 0, 0],
          [0, 0, 0, 5, 0, 0],
          [1, 0, 0, 2, 1, 4],
          [3, 5, 2, 0, 7, 0],
          [0, 0, 1, 7, 0, 2],
          [0, 0, 4, 0, 2, 0]
        ]
      end

      let(:stop_node) { 1 }

      let(:result) { { distance: 8, path: [0, 3, 1] } }

      it 'returns expected value' do
        expect(service.call(matrix, start_node, stop_node)).to eq result
      end
    end
  end
end
