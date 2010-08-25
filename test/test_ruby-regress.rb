require 'helper'
require 'ruby-regress'
require 'wrong'

module InDelta
  def in_delta?(other,delta=0.01)
    (self - other).abs < delta
  end
end

class Float
  include InDelta
end

class Fixnum
  include InDelta
end

class TestRubyRegress < Test::Unit::TestCase
  include Wrong::Assert
  
  def test_sums
    @a = [72,65,80,36,50,21,79,64,44,55]
    @b = [78,70,81,31,55,29,74,64,47,53]
    
    assert { Regress.sum(@a) == 566 }
    assert { Regress.sum(@b) == 582 }
    
    assert { Regress.sum(Regress.square(@a)) == 35344 }
    assert { Regress.sum(Regress.square(@b)) == 36962 }
    
    assert { Regress.multiply(@a,@b) == 36046 }
  end
  
  def test_stats
    @a = [68, 71, 62, 75, 58, 60, 67, 68, 71, 69, 68, 67, 63, 62, 60, 63, 65, 67, 63, 61]
    
    assert { Regress.min(@a).in_delta? 58 }
    assert { Regress.max(@a).in_delta? 75 }
    assert { Regress.sum(@a).in_delta? 1308 }
    assert { Regress.mean(@a).in_delta? 65.4 }
    assert { Regress.standard_deviation(@a).in_delta? 4.4057,0.0001 }
  end
  
  def test_malformed_input
    assert { rescuing { Regress.new([1,2], [1,2,3]) }.message == "Regress#initialize expects two vectors of equal length (given vectors of lengths 2, 3)." }
  end
  
  # This example is for population standard deviation, not sample -- so let's make sure we get it wrong!
  def test_sd_wikipedia_example
    a = [2,4,4,4,5,5,7,9]
    
    assert { Regress.standard_deviation(a) != 2 }
  end
  
  def test_correlation
    @a = [68, 71, 62, 75, 58, 60, 67, 68, 71, 69, 68, 67, 63, 62, 60, 63, 65, 67, 63, 61]
    @b = [4.1, 4.6, 3.8, 4.4, 3.2, 3.1, 3.8, 4.1, 4.3, 3.7, 3.5, 3.2, 3.7, 3.3, 3.4, 4.0, 4.1, 3.8, 3.4, 3.6]
    
    regress = Regress.new(@a, @b)
    
    assert { regress.r.in_delta? 0.73 }
  end
end