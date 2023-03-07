class StringCalculator
  attr_accessor :delimiter
  attr_reader :called_count

  ONE_THOUSAND = 1000

  def initialize(delimiter = ',')
    delimiters_array = delimiter.split(' ')
    @delimiter = "[#{delimiters_array.join('')}]"
    @called_count = 0
  end

  def add (args)
    @called_count += 1
    raise ArgumentError if /#{delimiter}$/.match(args.strip)
    numbers = []
    args.scan(/#{delimiter}?(-?\d+)/m) { |i| numbers << i[0].to_i }
    numbers = numbers.select { |i| i <= ONE_THOUSAND }
    negatives = numbers.select { |i| i < 0 }
    raise ArgumentError.new "negatives not allowed: " + negatives.join(",") unless negatives.empty?
    return numbers.reduce(0) { |sum,num| sum + num }
  end

end