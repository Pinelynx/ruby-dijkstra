class MatrixNotSquareError < StandardError
  def initialize(message = 'Matrix is not square')
    super
  end
end
