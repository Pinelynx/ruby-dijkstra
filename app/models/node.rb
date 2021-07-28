class Node
  attr_reader :visited, :tentative_distance, :ancestor

  def initialize(visited, tentative_distance, ancestor)
    @visited = visited
    @tentative_distance = tentative_distance
    @ancestor = ancestor
  end
end