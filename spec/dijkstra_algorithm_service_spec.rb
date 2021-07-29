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
      context 'when only one node' do
        let(:matrix) { [[0]] }
        let(:source_node) { 0 }
        let(:destination_node) { 0 }

        let(:result) { { distance: 0, path: [0] } }

        it 'returns expected value' do
          expect(service.call(matrix, source_node, destination_node)).to eq result
        end
      end

      context 'when all paths are bidirectional' do
        let(:matrix) do
          [
            [0, 0, 1, 3, 0, 0, 4, 0],
            [0, 0, 0, 5, 0, 0, 7, 0],
            [1, 0, 0, 2, 1, 4, 0, 0],
            [3, 5, 2, 0, 7, 0, 0, 10],
            [0, 0, 1, 7, 0, 2, 0, 0],
            [0, 0, 4, 0, 2, 0, 0, 6],
            [4, 7, 0, 0, 0, 0, 0, 7],
            [0, 0, 0, 10, 0, 6, 7, 0]
          ]
        end
        let(:source_node) { 0 }
        let(:destination_node) { 7 }

        let(:outbound_result) { { distance: 10, path: [0, 2, 4, 5, 7] } }
        let(:inbound_result) { { distance: 10, path: [7, 5, 4, 2, 0] } }

        it 'returns expected outbound value' do
          expect(service.call(matrix, source_node, destination_node)).to eq outbound_result
        end

        it 'returns expected inbound value' do
          expect(service.call(matrix, destination_node, source_node)).to eq inbound_result
        end
      end

      context 'when some paths are bidirectional' do
        let(:matrix) do
          [
            [0, 0, 1, 3, 0, 0, 4, 0],
            [0, 0, 0, 5, 0, 0, 7, 0],
            [0, 0, 0, 2, 1, 4, 0, 0],
            [3, 5, 2, 0, 7, 0, 0, 0],
            [0, 0, 0, 7, 0, 2, 0, 0],
            [0, 0, 4, 0, 2, 0, 0, 6],
            [0, 7, 0, 0, 0, 0, 0, 7],
            [0, 0, 0, 10, 0, 6, 7, 0]
          ]
        end
        let(:source_node) { 0 }
        let(:destination_node) { 7 }

        let(:outbound_result) { { distance: 10, path: [0, 2, 4, 5, 7] } }
        let(:inbound_result) { { distance: 13, path: [7, 3, 0] } }

        it 'returns expected outbound value' do
          expect(service.call(matrix, source_node, destination_node)).to eq outbound_result
        end

        it 'returns expected inbound value' do
          expect(service.call(matrix, destination_node, source_node)).to eq inbound_result
        end
      end

      context 'when no existing return path' do
        let(:matrix) do
          [
            [0, 0, 1, 3, 0, 0, 4, 0],
            [0, 0, 0, 5, 0, 0, 7, 0],
            [0, 0, 0, 2, 1, 4, 0, 0],
            [0, 5, 2, 0, 7, 0, 0, 0],
            [0, 0, 0, 7, 0, 2, 0, 0],
            [0, 0, 4, 0, 2, 0, 0, 6],
            [0, 7, 0, 0, 0, 0, 0, 7],
            [0, 0, 0, 10, 0, 6, 7, 0]
          ]
        end
        let(:source_node) { 0 }
        let(:destination_node) { 7 }

        let(:outbound_result) { { distance: 10, path: [0, 2, 4, 5, 7] } }
        let(:inbound_result) { { distance: Float::INFINITY, path: [] } }

        it 'returns expected outbound value' do
          expect(service.call(matrix, source_node, destination_node)).to eq outbound_result
        end

        it 'returns expected inbound value' do
          expect(service.call(matrix, destination_node, source_node)).to eq inbound_result
        end
      end
    end
  end
end
