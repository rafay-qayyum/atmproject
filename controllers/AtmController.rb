require_relative 'AccountController'
require_relative 'MachineController'
class AtmController
  def initialize()
    @accountsController=AccountController.new
    @machineController=MachineController.new
  end
  def withdraw(atm_num,machine_id,amount)
      return false if @accountsController.get_balance(atm_num)<amount
      return false if @machineController.get_cash_available(machine_id)<amount
      @accountsController.update_balance(atm_num,amount)
      @machineController.update_cash_available(machine_id,amount)
      return true
  end
end
