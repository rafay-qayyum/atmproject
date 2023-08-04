class UserAccount
  def initialize(name,atm_num,pin,expiry_date,balance)
    @name=name
    @atm_num=atm_num
    @pin=pin
    @expiry_date=expiry_date
    @balance=balance
  end
  def name
    @name
  end
  def atm_num
    @atm_num
  end
  def pin
    @pin
  end
  def pin=(pin)
    @pin=pin
  end
  def expiry_date
    @expiry_date
  end
  def balance
    @balance
  end
  def balance=(balance)
    @balance=balance
  end
end

class Machine
  def initialize(id,location,cash_available)
    @id=id
    @location=location
    @cash_available=cash_available
  end
  def id
    @id
  end
  def location
    @location
  end
  def cash_available
    @cash_available
  end
  def cash_available=(cash_available)
    @cash_available=cash_available
  end
end
