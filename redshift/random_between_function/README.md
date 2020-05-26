A function to generate a random number between two numbers you pass as arguments

random_between: Written in SQL. Different seed each time it's invoked, even in the same query.
2 arguments
  -min number
  -max number

random_seed: Written in Python. Specifying a seed will give a constant value, otherwise a random seed will be selected each invocation.
3 arguments
  -min number
  -max number
  -seed (optional)
NOTE: this function is overloaded--one version has three arguments and the other has two. If this is undesirable, the function with three arguments can be used by itself, but users will have to pass a literal NULL argument for the seed. 
