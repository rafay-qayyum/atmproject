require 'csv'

module Validators
  def self.number?(num)
    if num.match(/\d+/)
      return true
    else
      return false
    end
  end
  def self.get_number(mess)
    puts mess
    num=gets
    if !number?(num)
      puts "Must be Integer.."
      return nil
    end
    return num.to_i
  end
  def self.expiry_format_valid?(expiry_date)
    begin
      if expiry_date.match?(/^\d{2}-\d{2}-\d{4}$/) && Time.new(expiry_date[6..9],expiry_date[3..4],expiry_date[0..1])>Time.now
        return true
      else
        return false
      end
    rescue
      return false
    end
  end
end

class UserAccount
  def initialize(name,atm_num,pin,expiry_date,balance)
    @name=name
    @atm_num=atm_num
    @pin=pin
    @expiry_date=expiry_date
    @balance=balance
  end
  def name
    return @name
  end
  def atm_num
    return @atm_num
  end
  def pin
    return @pin
  end
  def pin=(pin)
    return @pin=pin
  end
  def expiry_date
    return @expiry_date
  end
  def balance
    return @balance
  end
  def balance=(balance)
    return @balance=balance
  end
end

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

class AccountsCsvDBHandler
  def initialize()
    @accounts_file='accounts.csv'
  end
  def read_account(atm_num)
    CSV.foreach(@accounts_file,headers:true) do |row|
      if row['atm_num'].to_i==atm_num
        return UserAccount.new(row['name'],row['atm_num'].to_i,row['pin'].to_i,row['expiry_date'],row['balance'].to_i)
      end
    end
    return nil
  end
  def atm_num_exists?(atm_num)
    CSV.foreach(@accounts_file,headers:true) do |row|
      if row['atm_num'].to_i==atm_num
        return true
      end
    end
    return false
  end
  def create_account(account)
    CSV.open(@accounts_file,'a') do |csv|
      csv<<[account.name,account.atm_num,account.pin,account.expiry_date,account.balance]
    end
  end
  def verify_account(atm_num,pin)
    CSV.foreach(@accounts_file,headers:true) do |row|
      if row['atm_num'].to_i==atm_num && row['pin'].to_i==pin
        return UserAccount.new(row['name'],row['atm_num'],row['pin'],row['expiry_date'],row['balance'].to_i)
      end
    end
    return nil
  end
  def write_data(accounts)
    CSV.open(@accounts_file,'w') do |csv|
      csv<<['name','atm_num','pin','expiry_date','balance']
      accounts.each do |account|
        csv<<[account.name,account.atm_num,account.pin,account.expiry_date,account.balance]
      end
    end
  end
  def read_data()
    accounts=[]
    CSV.foreach(@accounts_file,headers:true) do |row|
      accounts<< UserAccount.new(row['name'],row['atm_num'].to_i,row['pin'].to_i,row['expiry_date'],row['balance'].to_i)
    end
    return accounts
  end
  def update_balance(account_param)
    accounts=read_data()
    accounts.each do |account|
      if account.atm_num==account_param.atm_num
        account.balance=account_param.balance
      end
    end
    write_data(accounts)
  end
  def update_pin(account_param)
    accounts=read_data()
    accounts.each do |account|
      if account.atm_num==account_param.atm_num
        account.pin=account_param.pin
      end
    end
    write_data(accounts)
  end
  def delete_account(account)
    accounts=read_data()
    accounts.each do |acc|
      if acc.atm_num==account.atm_num
        account=acc
      end
    end
    accounts.delete(account)
    write_data(accounts)
  end
end

class MachineCsvHandler
  def initialize()
    @machine_file='machines.csv'
  end
  def read_data()
    machines=[]
    CSV.foreach(@machine_file,headers:true) do |row|
      machines<< Machine.new(row['id'].to_i,row['location'],row['cash_available'].to_i)
    end
    return machines
  end
  def write_data(machines)
    CSV.open(@machine_file,'w') do |csv|
      csv<<['id','location','cash_available']
      machines.each do |machine|
        csv<<[machine.id,machine.location,machine.cash_available]
      end
    end
  end
  def update_cash_available(machine_param)
    machines=read_data()
    machines.each do |machine|
      if machine.id==machine_param.id
        machine.cash_available=machine_param.cash_available
      end
    end
    write_data(machines)
  end
  def get_cash_available(id)
    machines=read_data()
    machines.each do |machine|
      if machine.id==id
        return machine.cash_available
      end
    end
  end
end

class AccountsController
  def initialize()
  end
  def create_account(account)
    accountsHandler=AccountsCsvDBHandler.new
    if accountsHandler.atm_num_exists?(account.atm_num)
      return false
    end
    accountsHandler.create_account(account)
    return true
  end
  def update_balance(atm_num,amount)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    if account==nil
      return false
    end
    account.balance=account.balance-amount
    accountsHandler.update_balance(account)
    return true
  end
  def update_pin(atm_num,new_pin)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    if account==nil
      return false
    end
    account.pin=new_pin
    accountsHandler.update_pin(account)
    return true
  end
  def delete_account(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    if account==nil
      return false
    end
    accountsHandler.delete_account(account)
    return true
  end
  def login(atm_num,pin)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.verify_account(atm_num,pin)
    if account==nil
      return false
    end
    return true
  end
  def get_balance(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    if account==nil
      return false
    end
    return account.balance
  end
  def get_name(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    if account==nil
      return false
    end
    return account.name
  end
  def atm_num_exists?(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    return accountsHandler.atm_num_exists?(atm_num)
  end
  def get_account(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    return accountsHandler.read_account(atm_num)
  end
end

class MachineController
  def get_cash_available(id)
    machineHandler=MachineCsvHandler.new
    return machineHandler.get_cash_available(id)
  end
  def update_cash_available(id,amount)
    machineHandler=MachineCsvHandler.new
    machines=machineHandler.read_data()
    machines.each do |machine|
      if machine.id==id
        machine.cash_available=machine.cash_available-amount
      end
    end
    machineHandler.write_data(machines)
  end
  def get_location(id)
    machineHandler=MachineCsvHandler.new
    machines=machineHandler.read_data()
    machines.each do |machine|
      if machine.id==id
        return machine.location
      end
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
      if machine.id==id
        return machine
      end
    end
    return nil
  end
end

class AtmController
  def initialize()
    @accountsController=AccountsController.new
    @machineController=MachineController.new
  end
  def withdraw(atm_num,machine_id,amount)
    if @accountsController.get_balance(atm_num)<amount
      return false
    end
    if @machineController.get_cash_available(machine_id)<amount
      return false
    end
    @accountsController.update_balance(atm_num,amount)
    @machineController.update_cash_available(machine_id,amount)
    return true
  end
end

class LoginInterface
  def initialize(atm_num,machine_id)
    @atm_num=atm_num
    @machine_id=machine_id
    @atmController=AtmController.new
    @accountsController=AccountsController.new
    @machineController=MachineController.new
  end
include Validators
  def update_pin()
    new_pin=Validators.get_number("Enter New PIN: ")
    if new_pin==nil
      return
    end
    if @accountsController.update_pin(@atm_num,new_pin)
      puts "PIN Updated Successfully.."
    else
      puts "Error Updating PIN.."
    end
  end

  def withdraw()
    amount=Validators.get_number("Enter Amount to Withdraw: ")
    if amount==nil
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
      choice= Validators.get_number("Enter Choice: ")
      if choice==nil
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

class AtmInterface
  def initialize()
  end
include Validators
  def start
    puts "Welcome to ATM"
    machine=select_machine()
    if machine==nil
      return
    end
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
    machine_id= Validators.get_number("Enter Machine ID: ")
    if machine_id==nil
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
      choice= Validators.get_number("Enter Choice: ")
      if choice==nil
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
    atm_num = Validators.get_number("Enter ATM Number: ")
    if atm_num==nil
      return
    end
    accountController=AccountsController.new
    if accountController.atm_num_exists?(atm_num)
      puts "Atm Number Already Exists.."
      return
    end
    pin = Validators.get_number("Enter PIN: ")
    if pin==nil
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
    accountController=AccountsController.new
    account=UserAccount.new(name,atm_num,pin,expiry_date,balance)
    accountController.create_account(account)
    puts "Account Created Successfully.."
  end

  def login(machine)
    atm_num = Validators.get_number("Enter ATM Number: ")
    if atm_num==nil
      return
    end
    pin = Validators.get_number("Enter PIN: ")
    if atm_num==nil
      return
    end
    accountController=AccountsController.new
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


atmInterface=AtmInterface.new
atmInterface.start()
