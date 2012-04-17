class Regress
  attr_reader :r, :slope, :intercept
  
  # Create a Regress object from two vectors +a+ and +b+. Note that +a+ and +b+ must be of the same length.
  def initialize(a,b=nil)
    if b.nil?
      # Don't do regression if we're only given one item
    else
      raise "Regress#initialize expects two vectors of equal length (given vectors of lengths #{a.size}, #{b.size})." if a.size != b.size
      
      sa,sb = *[a,b].map { |d| Regress.sum(d) }
      sa2,sb2 = *[a,b].map { |d| Regress.sum(Regress.square(d)) }
      sab = Regress.multiply(a,b)
      n = a.size
      
      @r = (n * sab - sa * sb) / (( (n * sa2 - sa**2) * (n * sb2 - sb**2) ) ** 0.5)
      @r = 0.0 if @r.nan?
    end
  end
  
  def Regress.sum(vector)
    vector.inject(0) { |s,x| s += x }
  end
  
  def Regress.square(vector)
    vector.map { |x| x**2 }
  end
  
  def Regress.multiply(a,b)
    (0..a.size-1).inject(0) { |s,i| s += a[i] * b[i] }
  end
  
  def Regress.min(vector)
    vector.sort.shift
  end
  
  def Regress.max(vector)
    vector.sort.pop
  end
  
  def Regress.mean(vector)
    Regress.sum(vector) / vector.size.to_f
  end
  
  def Regress.standard_deviation(vector)
    mean = Regress.mean(vector)
    (vector.collect { |x| (x-mean)**2 }.inject(0) { |s,x| s += x } / (vector.size.to_f-1)) ** 0.5
  end
end