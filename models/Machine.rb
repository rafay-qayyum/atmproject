class Machine
  def initialize(id,location,cash_available)
    @id=id
    @location=location
    @cash_available=cash_available
  end
  def id
    return @id
  end
  def location
    return @location
  end
  def cash_available
    return @cash_available
  end
  def cash_available=(cash_available)
    return @cash_available=cash_available
  end
end
