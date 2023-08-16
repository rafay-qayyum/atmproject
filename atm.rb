# Purpose: This file is the main file for the ATM program. It creates an instance of the AtmInterface class and calls the start method.
require_relative 'views/AtmInterface.rb'

atmInterface=AtmInterface.new
atmInterface.start()
