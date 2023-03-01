defmodule Derivative do

@type literal() :: {:num, number()} | {:var, atom()}

@type expr() :: literal()
  | {:mul, expr(), expr()}
  | {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:sqrt, expr()}
  | {:sin, expr()}
  | {:cos, expr()}



# Tests
def test() do
  #{:add, {:add, {:mul, 0, {:var, :x}}, {:mul, {:num, 2}, 1}}, 0}

  e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)

  IO.write("Expression: #{pprint(e)}\n")
  IO.write("Derivative: #{pprint(d)}\n")
  IO.write("Simplified: #{pprint(simplify(d))}\n")
  :ok
end



#----------- Derivative rules -----------#
def deriv({:num, _}, _) do {:num, 0} end
def deriv({:var, v}, v) do {:num, 1} end
def deriv({:var, _}, _) do {:num, 0} end

# Multiplication
def deriv({:mul, e1, e2}, v) do
  {:add,
  {:mul, deriv(e1, v), e2},
  {:mul, e1, deriv(e2, v)}}
end

# Addition
def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end

# Exponential
def deriv({:exp, e, {:num, n}}, v) do
  {:mul,
    {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
    deriv(e, v)
  }
end

# Logarithmic
def deriv({:ln, e}, v) do
  {:mul,
  deriv(e, v),
  {:div, {:num, 1}, e}
  }
end

# Division

def deriv({:div, e1, e2}, v) do
  {:div,
  {:sub,
  {:mul, deriv(e1, v), e2},
  {:mul, e1, deriv(e2, v)},
  },
  {:exp, e2, {:num, 2}}
}
end


# Square root
def deriv({:sqrt, e}, v) do
  {:div,
    deriv(e, v),
    {:mul, {:num, 2}, {:sqrt, e}
    }
  }
end

# Sinus function
def deriv({:sin, e}, v) do
  {:mul,
  deriv(e, v),
  {:cos, e}}
end


# Simplification
def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
def simplify(e) do e end

def simplify_add({:num, 0}, e2) do e2 end
def simplify_add(e1, {:num, 0})  do e1 end
def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end

def simplify_mul(_, {:num, 0})  do {:num, 0} end
def simplify_mul({:num, 0}, _) do {:num, 0} end
def simplify_mul({:num, 1}, e2) do e2 end
def simplify_mul(e1, {:num, 1})  do e1 end
def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
def simplify_mul(e1, e2)  do {:mul, e1, e2} end

def simplify_exp(_, {:num, 0}) do {:num, 1} end
def simplify_exp(e1, {:num, 1}) do e1 end
def simplify_exp(e1, e2) do {:exp, e1, e2} end

def simplify_ln({:num, 1}) do {:num, 0} end
def simplify_ln({:num, 0}) do :nil end
def simplify_ln(e) do {:ln, e} end

def simplify_div(_, {:num, 0}) do :nil end
def simplify_div({:num, 0}, _) do {:num, 0} end
def simplify_div(e1, {:num, 1}) do e1 end
def simplify_div(e1, e2) do {:div, e1, e2} end

def simplify_sqrt({:num, 1}) do {:num, 1} end
def simplify_sqrt({:num, 0}) do {:num, 0} end
def simplify_sqrt(e) do {:sqrt, e} end

def simplify_sin({:num, 0}) do {:num, 0} end
def simplify_sin(e) do {:sin, e} end


# pprint
def pprint({:num, n}) do "#{n}" end
def pprint({:var, v}) do "#{v}" end
def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
def pprint({:sub, e1, e2}) do "(#{pprint(e1)} - #{pprint(e2)})" end
def pprint({:exp, e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
def pprint({:ln, e}) do "ln(#{pprint(e)})" end
def pprint({:div, e1, e2}) do "(#{pprint(e1)}/#{pprint(e2)})" end
def pprint({:sqrt, e}) do "sqrt(#{pprint(e)})" end
def pprint({:sin, e}) do "sin(#{pprint(e)})" end

end
