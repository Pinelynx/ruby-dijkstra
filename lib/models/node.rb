class Node
  attr_accessor :index, :tentative_distance, :ancestor

  def initialize(index, tentative_distance, ancestor)
    @index = index
    @tentative_distance = tentative_distance
    @ancestor = ancestor
  end

  def eql?(other)
    @index == other.index
  end

  def hash
    [@index].hash
  end
end
