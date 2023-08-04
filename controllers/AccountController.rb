require_relative '../repositories/AccountCsvHandler.rb'
require_relative '../models/UserAccount.rb'

class AccountController
  def create_account(account)
    accountsHandler=AccountCsvHandler.new
    return false if accountsHandler.atm_num_exists?(account.atm_num)
    accountsHandler.create_account(account)
    return true
  end
  def update_balance(atm_num,amount)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    account.balance=account.balance-amount
    accountsHandler.update_balance(account)
    return true
  end
  def update_pin(atm_num,new_pin)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    account.pin=new_pin
    accountsHandler.update_pin(account)
    return true
  end
  def delete_account(atm_num)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    accountsHandler.delete_account(account)
    return true
  end
  def login(atm_num,pin)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.verify_account(atm_num,pin)
    return account==nil ? false : true
  end
  def get_balance(atm_num)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.read_account(atm_num)
    return account==nil ? false : account.balance
  end
  def get_name(atm_num)
    accountsHandler=AccountCsvHandler.new
    account=accountsHandler.read_account(atm_num)
    return account==nil ? false : account.name
  end
  def atm_num_exists?(atm_num)
    accountsHandler=AccountCsvHandler.new
    return accountsHandler.atm_num_exists?(atm_num)
  end
  def get_account(atm_num)
    accountsHandler=AccountCsvHandler.new
    return accountsHandler.read_account(atm_num)
  end
end
