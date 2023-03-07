#!/usr/bin/env ruby
require './string_calculator.rb'

RSpec.describe StringCalculator do
  context "Given valid arguments" do
    calc = StringCalculator.new
    it "sums up two valid numbers" do
      result = calc.add "1,2"
      expect(result).to eq(3)
    end
    it "sums one valid number" do
      result = calc.add "3"
      expect(result).to eq(3)
    end
    it "takes an empty string" do
      result = calc.add ""
      expect(result).to eq(0)
    end
  end

  context "Given an unknown amount of numbers" do
    calc = StringCalculator.new
    it "sums up various valid numbers" do
      result = calc.add "1000,100,10,1"
      expect(result).to eq(1111)
    end
  end

  context "Given new lines as part of the string" do
    calc = StringCalculator.new
    it "sums up two valid numbers with new line in between" do
      result = calc.add "1000\n100,10,1"
      expect(result).to eq(1111)
    end
    it "sums up one valid number plus a symbol" do
      expect{ calc.add "1,2,\n" }.to raise_error(ArgumentError)
    end
  end

  context "Given a variation of delimiters" do
    calc = StringCalculator.new(';')
    it "sums up two valid numbers with new line in between" do
      result = calc.add "1000\n100;10;1"
      expect(result).to eq(1111)
    end
    it "sums up two valid numbers with new line in between" do
      calc.delimiter = ','
      result = calc.add "1000\n100,10,1"
      expect(result).to eq(1111)
    end
  end

  context "Given negative numbers as part of arguments" do
    calc = StringCalculator.new
    it "sums up two numbers, one negative" do
      expect{ calc.add "1,-2" }.to raise_error(ArgumentError, /negatives not allowed/)
    end
    it "sums up multiple negative numbers" do
      expect{ calc.add "1,-2,-3,-100" }.to raise_error(ArgumentError, /-2,-3,-100/)
    end
  end

  context "When all arguments are valid" do
    calc = StringCalculator.new
    it "count all calls with accepted numbers" do
      calc.add "1,2,3"
      calc.add "1"
      calc.add ""
      expect(3).to eq(calc.called_count)
    end
  end

  context "When called with invalid arguments" do
    calc = StringCalculator.new
    it "count all calls even when invalid arguments" do
      calc.add "1,2,3"
      expect{ calc.add "1," }.to raise_error(ArgumentError)
      expect{ calc.add "1,-2,3" }.to raise_error(ArgumentError)
      expect(3).to eq(calc.called_count)
    end
  end

  context "Given numbers larger than 1000" do
    calc = StringCalculator.new
    it "ignore all of them" do
      result = calc.add "1001,20000,30000"
      expect(0).to eq(result)
    end
    it "ignores some of them" do
      result = calc.add "1,999,1000,1001"
      expect(2000).to eq(result)
    end
  end

  context "Given delimiters of any lenght" do
    calc = StringCalculator.new
    it "accepts any number of delimiters" do
      result = calc.add "1,,,,,2,3,,,4"
      expect(10).to eq(result)
    end
  end

  context "Given multiple number of delimiters" do
    calc = StringCalculator.new(", % |")
    it "acepts multiple delimiters" do
      result = calc.add "1,2%3|4"
      expect(10).to eq(result)
    end

    it "acepts multiple delimiters of any lenght" do
      result = calc.add "1,,,,,2%%%%3|||4"
      expect(10).to eq(result)
    end

    it "acepts multiple delimiters of any lenght (mixed)" do
      result = calc.add "1,,%,%,2%%|%3|,%4"
      expect(10).to eq(result)
    end
  end
end
