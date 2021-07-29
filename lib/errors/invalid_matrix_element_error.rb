class InvalidMatrixElementError < StandardError
  def initialize(message = 'Matrix contains invalid element')
    super(message)
  end
end
