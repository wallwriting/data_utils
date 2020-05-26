CREATE OR REPLACE function random_seed(lowArg BIGINT, highArg BIGINT, seedArg BIGINT)
RETURNS BIGINT
volatile 
AS $$
    #imports seed and pseudo random
    from random import seed
    from random import random
    # if no argument passed, set to random
    if seedArg is None:
        seedArg = random()
    else:
        seedArg = seedArg
    seed(seedArg)
    # generate random number
    return random() * (highArg-lowArg +1) + lowArg

$$ LANGUAGE plpythonu;




/*Overloads the function to allow for usage passing only 2 arguments*/
CREATE OR REPLACE function random_seed(lowArg BIGINT, highArg BIGINT)
RETURNS BIGINT
volatile 
AS $$
    #imports seed and pseudo random
    from random import seed
    from random import random
    seed(random())
    # generate random number
    return random() * (highArg-lowArg +1) + lowArg
$$ LANGUAGE plpythonu;