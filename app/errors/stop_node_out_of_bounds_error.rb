class StopNodeOutOfBoundsError < StandardError
  def initialize(message = 'Stop node is not a valid node')
    super
  end
end
