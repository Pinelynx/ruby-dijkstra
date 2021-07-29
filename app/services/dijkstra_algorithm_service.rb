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

  def calculate(matrix, start_node, stop_node) # rubocop:disable Metrics/MethodLength
    unvisited_nodes = nodes = setup_nodes(matrix, start_node)

    while unvisited_nodes.any?
      current_node = next_unvisited_node(unvisited_nodes)

      current_node.visited = true
      unvisited_nodes = nodes.reject(&:visited)

      matrix.row(current_node.index).to_a.each_with_index do |distance, index|
        next if update_visited_node(nodes, unvisited_nodes, current_node, distance, index)

        break if done(unvisited_nodes, current_node, stop_node)
      end
    end

    { distance: nodes[stop_node].tentative_distance, path: calculate_path(nodes, start_node, stop_node) }
  end

  def setup_nodes(matrix, start_node)
    nodes = []

    (0..(matrix.row_count - 1)).each do |index|
      nodes << Node.new(index, false, INFINITY, -INFINITY)
    end

    nodes[start_node].tentative_distance = 0

    nodes
  end

  def next_unvisited_node(unvisited_nodes)
    distance = INFINITY
    next_unvisited_node = nil

    unvisited_nodes.each do |current_node|
      current_tentative_distance = current_node.tentative_distance
      if current_tentative_distance <= distance
        distance = current_tentative_distance
        next_unvisited_node = current_node
      end
    end

    next_unvisited_node
  end

  def update_visited_node(nodes, unvisited_nodes, current_node, distance, index)
    return true unless unvisited_nodes.map(&:index).include?(index) && distance.positive?

    visited_node = nodes[index]

    tentative_distance = current_node.tentative_distance + distance

    return false if tentative_distance >= visited_node.tentative_distance

    visited_node.tentative_distance = tentative_distance
    visited_node.ancestor = current_node.index

    false
  end

  def done(unvisited_nodes, current_node, stop_node)
    current_node.index == stop_node || unvisited_nodes.map(&:tentative_distance).min == INFINITY
  end

  def calculate_path(nodes, start_node, stop_node)
    path = [stop_node]
    node = stop_node

    while nodes[node].ancestor != start_node
      node = nodes[node].ancestor
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
