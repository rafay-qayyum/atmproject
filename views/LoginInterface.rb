require_relative '../controllers/AtmController.rb'
require_relative '../controllers/AccountController.rb'
require_relative '../controllers/MachineController.rb'
require_relative '../validators.rb'

class LoginInterface
  def initialize(atm_num,machine_id)
    @atm_num=atm_num
    @machine_id=machine_id
    @atmController=AtmController.new
    @accountsController=AccountController.new
    @machineController=MachineController.new
  end
include Validators
  def update_pin()
    puts "Enter New PIN: "
    new_pin=Validators.get_number()
    if new_pin==nil
      puts "Invalid PIN.."
      return
    end
    if @accountsController.update_pin(@atm_num,new_pin)
      puts "PIN Updated Successfully.."
    else
      puts "Error Updating PIN.."
    end
    return
  end

  def withdraw()
    puts "Enter Amount to Withdraw: "
    amount=Validators.get_number()
    if amount==nil
      puts "Invalid Amount.."
      return
    end
    if !@atmController.withdraw(@atm_num,@machine_id,amount)
      puts "Error Withdrawing Amount.."
      balance=@accountsController.get_balance(@atm_num)
      cash_available=@machineController.get_cash_available(@machine_id)
      if balance<amount
        puts "Insufficient Balance.."
      elsif cash_available<amount
        puts "Insufficient Cash in ATM.."
      end
    else
      puts "Amount Withdrawn Successfully.."
    end
  end

  def delete_account()
    if @accountsController.delete_account(@atm_num)
      puts "Account Deleted Successfully.."
    else
      puts "Error Deleting Account.."
    end
  end
  def check_balance()
    puts "Your Balance is #{@accountsController.get_balance(@atm_num)}"
  end
  def display_login_menu()
    puts "Welcome #{@accountsController.get_name(@atm_num)}"
    while true
      puts "1. Update pin"
      puts "2. Withdraw"
      puts "3. Delete account"
      puts "4. Check balance"
      puts "5. Exit"
      puts "Enter Choice: "
      choice= Validators.get_number()
      if choice==nil
        puts "Invalid Choice.."
        next
      end
      case choice
      when 1
        update_pin()
      when 2
        withdraw()
      when 3
        delete_account()
        puts "Logged out.."
        break
      when 4
        check_balance()
      when 5
        break
      else
        puts "Invalid Choice"
      end
    end
  end
end
