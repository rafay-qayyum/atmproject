require_relative '../controllers/AccountController.rb'
require_relative '../controllers/MachineController.rb'
require_relative '../controllers/AtmController.rb'
require_relative '../validators.rb'
require_relative 'LoginInterface.rb'

class AtmInterface
  def initialize()
  end
include Validators
  def start
    puts "Welcome to ATM"
    machine=select_machine()
    return if machine==nil
    machine_interface(machine)
  end

  def select_machine()
    machineController=MachineController.new
    machines=machineController.get_machines()
    if machines.length==0
      put "No Machines are Available"
      return nil
    end
    puts "Machines Available: "
    machines.each do |machine|
      puts "#{machine.id}\t #{machine.location}"
    end
    puts "Enter Machine ID: "
    machine_id= Validators.get_number()
    if machine_id==nil
      puts  "Invalid Machine ID.."
      return
    end
    if machineController.get_machine(machine_id)!=nil
      return machine_id
    end
    puts "Invalid Machine ID.."
    return
  end

  def machine_interface(machine_id)
    machineController=MachineController.new
    while true
      puts "Welcome to #{machineController.get_location(machine_id)} ATM"
      puts "1. Create Account"
      puts "2. Login"
      puts "3. Exit"
      puts "Enter Choice: "
      choice= Validators.get_number()
      if choice==nil
        puts "Invalid Choice.."
        next
      end
      case choice
      when 1
        create_account
      when 2
        login(machine_id)
      when 3
        break
      else
        puts "Invalid Choice.."
      end
    end
  end

  def create_account
    puts "Enter Name: "
    name=gets.chomp
    puts "Enter ATM Number: "
    atm_num = Validators.get_number()
    if atm_num==nil
      puts "Invalid ATM Number.."
      return
    end
    accountController=AccountController.new
    if accountController.atm_num_exists?(atm_num)
      puts "Atm Number Already Exists.."
      return
    end
    puts "Enter PIN: "
    pin = Validators.get_number()
    if pin==nil
      puts "Invalid PIN.."
      return
    end
    puts "Enter Expiry Date(Format: DD-MM-YYYY): "
    expiry_date=gets.chomp
    if !Validators.expiry_format_valid?(expiry_date)
      puts "Invalid Expiry Date.."
      return
    end
    puts "Enter Balance: "
    balance=gets.chomp.to_i
    accountController=AccountController.new
    account=UserAccount.new(name,atm_num,pin,expiry_date,balance)
    accountController.create_account(account)
    puts "Account Created Successfully.."
  end

  def login(machine)
    puts "Enter ATM Number: "
    atm_num = Validators.get_number()
    if atm_num==nil
      puts "Invalid ATM Number.."
      return
    end
    puts "Enter PIN: "
    pin = Validators.get_number()
    if pin==nil
      puts "Invalid PIN.."
      return
    end
    accountController=AccountController.new
    status=accountController.login(atm_num,pin)
    if status==false
      puts "Invalid Credentials.."
      return
    else
      account=accountController.get_account(atm_num)
      if !Validators.expiry_format_valid?(account.expiry_date)
        puts "Your Card has Expired.."
        return
      else
        puts "Login Successful.."
        loginInterface=LoginInterface.new(atm_num,machine)
        loginInterface.display_login_menu()
      end
    end
  end
end
