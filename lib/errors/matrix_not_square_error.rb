class MatrixNotSquareError < StandardError
  def initialize(message = 'Matrix is not square')
    super(message)
  end
end
