require 'app/errors/matrix_not_square_error'
require 'app/errors/start_node_out_of_bounds_error'
require 'app/errors/stop_node_out_of_bounds_error'
require 'app/models/node'
require 'singleton'
require 'set'
require 'matrix'

class DijkstraAlgorithmService
  include Singleton

  INFINITY = Float::INFINITY

  def call(data, start_node, stop_node)
    return 0 unless data&.any? && start_node != stop_node

    matrix = Matrix.rows(data)

    check_params(matrix, start_node, stop_node)

    calculate(matrix, start_node, stop_node)
  end

  private

  def calculate(matrix, start_node, stop_node)
    unvisited_nodes = Set[]
    tentative_distances = []
    ancestors = []

    setup(matrix, unvisited_nodes, tentative_distances, ancestors)

    tentative_distances[start_node] = 0

    while unvisited_nodes.any?
      current_node = next_unvisited_node(unvisited_nodes, tentative_distances)

      unvisited_nodes.delete(current_node)

      matrix.row(current_node).each_with_index do |distance, index|
        next unless unvisited_nodes.include?(index) && distance.positive?

        tentative_distance = tentative_distances[current_node] + distance

        if tentative_distance < tentative_distances[index]
          tentative_distances[index] = tentative_distance
          ancestors[index] = current_node
        end

        break if current_node == stop_node || unvisited_nodes.min == INFINITY
      end
    end

    { distance: tentative_distances[stop_node],
      path: calculate_path(ancestors, start_node, stop_node) }
  end

  def setup(matrix, unvisited_nodes, tentative_distances, ancestors)
    (0..(matrix.row_count - 1)).each do |index|
      unvisited_nodes.add(index)
      tentative_distances << INFINITY
      ancestors << -INFINITY
    end
  end

  def next_unvisited_node(unvisited_nodes, tentative_distances)
    distance = INFINITY
    node = nil

    unvisited_nodes.each do |current_unvisited_node|
      current_tentative_distance = tentative_distances[current_unvisited_node]
      if tentative_distances[current_unvisited_node] <= distance
        distance = current_tentative_distance
        node = current_unvisited_node
      end
    end

    node
  end

  def calculate_path(ancestors, start_node, stop_node)
    path = [stop_node]
    node = stop_node

    while ancestors[node] != start_node
      node = ancestors[node]
      path.prepend(node)
    end

    path.prepend(start_node)
  end

  def check_params(matrix, start_node, stop_node)
    raise MatrixNotSquareError unless matrix.square?

    raise StartNodeOutOfBoundsError if start_node.negative? || start_node >= matrix.row_count

    raise StopNodeOutOfBoundsError if stop_node.negative? || stop_node >= matrix.row_count
  end
end
