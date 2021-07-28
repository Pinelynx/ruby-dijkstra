class StartNodeOutOfBoundsError < StandardError
  def initialize(message = 'Start node is not a valid node')
    super
  end
end
