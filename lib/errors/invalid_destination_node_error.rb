class InvalidDestinationNodeError < StandardError
  def initialize(message = 'Destination node parameter error is invalid')
    super(message)
  end
end
