require 'csv'
require_relative '../models/Machine.rb'
class MachineCsvHandler
  def initialize()
    @machine_file="data/machines.csv"
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
      machine.cash_available=machine_param.cash_available if machine.id==machine_param.id
    end
    write_data(machines)
  end
  def get_cash_available(id)
    machines=read_data()
    machines.each do |machine|
      return machine.cash_available if machine.id==id
    end
  end
end
