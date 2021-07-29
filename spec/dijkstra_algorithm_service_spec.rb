require 'lib/services/dijkstra_algorithm_service'

RSpec.describe DijkstraAlgorithmService, type: :class do
  subject(:service) { described_class.instance }

  let(:matrix) { [[0]] }
  let(:source_node) { 0 }
  let(:destination_node) { 0 }

  describe '#call' do
    context 'when input is invalid' do
      context 'when input matrix is nil' do
        let(:matrix) { nil }

        it 'raises EmptyMatrixError' do
          expect { service.call(matrix, source_node, destination_node) }.to raise_error EmptyMatrixError
        end
      end

      context 'when input matrix is empty' do
        let(:matrix) { [] }

        it 'raises EmptyMatrixError' do
          expect { service.call(matrix, source_node, destination_node) }.to raise_error EmptyMatrixError
        end
      end

      context 'when input matrix contains nil element' do
        let(:matrix) { [[1, 2], [nil, 4]] }

        it 'raises EmptyMatrixError' do
          expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidMatrixElementError
        end
      end

      context 'when input matrix contains negative element' do
        let(:matrix) { [[1, 2], [-1, 4]] }

        it 'raises EmptyMatrixError' do
          expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidMatrixElementError
        end
      end

      context 'when input matrix is not square' do
        let(:matrix) do
          [
            [1, 2, 3],
            [4, 5, 6]
          ]
        end

        it 'raises MatrixNotSquareError' do
          expect { service.call(matrix, source_node, destination_node) }.to raise_error MatrixNotSquareError
        end
      end

      context 'when source node invalid' do
        context 'when source node negative' do
          let(:source_node) { -1 }

          it 'raises InvalidSourceNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidSourceNodeError
          end
        end

        context 'when source node out of bounds' do
          let(:source_node) { 1 }

          it 'raises InvalidSourceNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidSourceNodeError
          end
        end

        context 'when source node is not integer' do
          let(:source_node) { 1.1 }

          it 'raises InvalidSourceNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidSourceNodeError
          end
        end
      end

      context 'when destination node invalid' do
        context 'when destination node negative' do
          let(:destination_node) { -1 }

          it 'raises InvalidDestinationNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidDestinationNodeError
          end
        end

        context 'when destination node out of bounds' do
          let(:destination_node) { 1 }

          it 'raises InvalidDestinationNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidDestinationNodeError
          end
        end

        context 'when destination node is not integer' do
          let(:destination_node) { 1.1 }

          it 'raises InvalidDestinationNodeError' do
            expect { service.call(matrix, source_node, destination_node) }.to raise_error InvalidDestinationNodeError
          end
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

      let(:destination_node) { 1 }

      let(:result) { { distance: 8, path: [0, 3, 1] } }

      it 'returns expected value' do
        expect(service.call(matrix, source_node, destination_node)).to eq result
      end
    end
  end
end
