
module Validators
  def self.number?(num)
    return num.match(/\d+/) ? true : false
  end
  def self.get_number()
    num=gets
    return number?(num) ? num.to_i : nil
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
