require_relative '../models/Machine.rb'
require_relative '../repositories/MachineCsvHandler.rb'

class MachineController
  def get_cash_available(id)
    machineHandler=MachineCsvHandler.new
    return machineHandler.get_cash_available(id)
  end
  def update_cash_available(id,amount)
    machineHandler=MachineCsvHandler.new
    machines=machineHandler.read_data()
    machines.each do |machine|
      machine.cash_available=machine.cash_available-amount if machine.id==id
    end
    machineHandler.write_data(machines)
  end
  def get_location(id)
    machineHandler=MachineCsvHandler.new
    machines=machineHandler.read_data()
    machines.each do |machine|
        return machine.location if machine.id==id
    end
    return nil
  end
  def get_machines()
    machineHandler=MachineCsvHandler.new
    return machineHandler.read_data()
  end
  def get_machine(id)
    machineHandler=MachineCsvHandler.new
    machines=machineHandler.read_data()
    machines.each do |machine|
        return machine if machine.id==id
    end
    return nil
  end
end
