class Node
  attr_accessor :index, :visited, :tentative_distance, :ancestor

  def initialize(index, visited, tentative_distance, ancestor)
    @index = index
    @visited = visited
    @tentative_distance = tentative_distance
    @ancestor = ancestor
  end
end
