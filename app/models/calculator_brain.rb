class CalculatorBrain
  PRECEDENCE = {"*" => 2, "/" => 2, "+" => 1, "-" => 1 }
  def eval(formula)
    calculate convert formula
  end

  def convert(formula)
    output_queue = []
    stack = []
    formula.scan(/((?<!\d)-?[\d.]+|.)/).flatten.each do |token|
      while not token =~ /(?<!\d)-?[\d.]+/ and stack.any? and
          PRECEDENCE[token] <= PRECEDENCE[stack[0]]
        output_queue << stack.pop
      end
      if token.match(/-?[\d.]+/)
        output_queue << token.to_f
      else
        stack.push token
      end
    end
    output_queue + stack.reverse
  end

  def calculate(postfix_expression)
    postfix_expression.inject([]) do |stack, token|
      if token.is_a? String
        stack << stack.delete_at(-2).send(token, stack.pop)
      else
        stack << token
      end
    end.first
  end
end