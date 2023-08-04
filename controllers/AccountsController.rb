require_relative '../repositories/AccountsCsvDBHandler.rb'
require_relative '../models/UserAccount.rb'

class AccountsController
  def create_account(account)
    accountsHandler=AccountsCsvDBHandler.new
    return false if accountsHandler.atm_num_exists?(account.atm_num)
    accountsHandler.create_account(account)
    return true
  end
  def update_balance(atm_num,amount)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    account.balance=account.balance-amount
    accountsHandler.update_balance(account)
    return true
  end
  def update_pin(atm_num,new_pin)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    account.pin=new_pin
    accountsHandler.update_pin(account)
    return true
  end
  def delete_account(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    return false if account==nil
    accountsHandler.delete_account(account)
    return true
  end
  def login(atm_num,pin)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.verify_account(atm_num,pin)
    return account==nil ? false : true
  end
  def get_balance(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    return account==nil ? false : account.balance
  end
  def get_name(atm_num)
    accountsHandler=AccountsCsvDBHandler.new
    account=accountsHandler.read_account(atm_num)
    return account==nil ? false : account.name
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
