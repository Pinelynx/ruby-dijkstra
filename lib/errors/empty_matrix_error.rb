class EmptyMatrixError < StandardError
  def initialize(message = 'Matrix contains no elements')
    super(message)
  end
end
