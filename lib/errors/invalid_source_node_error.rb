class InvalidSourceNodeError < StandardError
  def initialize(message = 'Source node parameter error is invalid')
    super(message)
  end
end
