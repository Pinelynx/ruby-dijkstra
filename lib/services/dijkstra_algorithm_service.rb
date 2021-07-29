require 'lib/errors/empty_matrix_error'
require 'lib/errors/invalid_destination_node_error'
require 'lib/errors/invalid_matrix_element_error'
require 'lib/errors/invalid_source_node_error'
require 'lib/errors/matrix_not_square_error'
require 'lib/models/node'
require 'singleton'
require 'set'
require 'matrix'

class DijkstraAlgorithmService
  include Singleton

  INFINITY = Float::INFINITY

  def call(data, source_node, destination_node)
    matrix = check_params(data, source_node, destination_node)

    nodes = calculate_nodes(matrix, source_node, destination_node)

    { distance: nodes[destination_node].tentative_distance, path: calculate_path(nodes, source_node, destination_node) }
  end

  private

  def calculate_nodes(matrix, source_node, destination_node) # rubocop:disable Metrics/MethodLength
    unvisited_nodes = nodes = setup_nodes(matrix, source_node)

    while unvisited_nodes.any?
      current_node = next_unvisited_node(unvisited_nodes)

      current_node.visited = true
      unvisited_nodes = nodes.reject(&:visited)

      matrix.row(current_node.index).to_a.each_with_index do |distance, index|
        next if update_visited_node(nodes, unvisited_nodes, current_node, distance, index)

        break if done(unvisited_nodes, current_node, destination_node)
      end
    end

    nodes
  end

  def setup_nodes(matrix, source_node)
    nodes = []

    (0..(matrix.row_count - 1)).each do |index|
      nodes << Node.new(index, false, INFINITY, -INFINITY)
    end

    nodes[source_node].tentative_distance = 0

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

  def done(unvisited_nodes, current_node, destination_node)
    current_node.index == destination_node || unvisited_nodes.map(&:tentative_distance).min == INFINITY
  end

  def calculate_path(nodes, source_node, destination_node)
    return [] if nodes[destination_node].tentative_distance == INFINITY

    path = [destination_node]
    node = destination_node

    while nodes[node].ancestor != source_node && nodes[node].ancestor != -INFINITY
      node = nodes[node].ancestor
      path.prepend(node)
    end

    source_node == destination_node ? path : path.prepend(source_node)
  end

  def check_params(data, source_node, destination_node)
    raise EmptyMatrixError unless data&.any?

    matrix = Matrix.rows(data)

    raise MatrixNotSquareError unless matrix.square?

    raise InvalidMatrixElementError unless matrix.flat_map.none? { |element| element.nil? || element.negative? }

    upper_bound = matrix.row_count

    check_node_parameter(source_node, upper_bound, InvalidSourceNodeError)
    check_node_parameter(destination_node, upper_bound, InvalidDestinationNodeError)

    matrix
  end

  def check_node_parameter(node, upper_bound, error)
    raise error if node.nil? || node.to_i != node || node.negative? || node >= upper_bound
  end
end
