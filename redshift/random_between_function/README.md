A function to generate a random number between two numbers you pass as arguments
<br>
Collectively, this functions can be used to fill dummy data into tables for testing purposes.
<br>
random_between: Written in SQL. Different seed each time it's invoked, even in the same query. Two versions, one for integer and one for decimal<br>
2 arguments<br>
  -min number<br>
  -max number<br>

<br>
random_seed: Written in Python. Specifying a seed will give a constant value, otherwise a random seed will be selected each invocation.<br>
3 arguments<br>
  -min number<br>
  -max number<br>
  -seed (optional)<br>
NOTE: this function is overloaded--one version has three arguments and the other has two. If this is undesirable, the function with three arguments can be used by itself, but users will have to pass a literal NULL argument for the seed. 
<br>
random_timestamp: Written in SQL. Returns a random date between the dates specified. Two versions, one for date and one for timestamp
<br>
random_jibberish: Written in Python. Returns a random string of specified length.
