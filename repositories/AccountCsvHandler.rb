require 'csv'
require_relative '../models/UserAccount.rb'
class AccountCsvHandler
  def initialize()
    @accounts_file='data/accounts.csv'
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
      return true if row['atm_num'].to_i==atm_num
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
      account.balance=account_param.balance if account.atm_num==account_param.atm_num
    end
    write_data(accounts)
  end
  def update_pin(account_param)
    accounts=read_data()
    accounts.each do |account|
      account.pin=account_param.pin if account.atm_num==account_param.atm_num
    end
    write_data(accounts)
  end
  def delete_account(account)
    accounts=read_data()
    accounts.each do |acc|
      account=acc if acc.atm_num==account.atm_num
    end
    accounts.delete(account)
    write_data(accounts)
  end
end
