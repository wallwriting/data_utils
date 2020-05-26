CREATE OR REPLACE function random_between(lowArg BIGINT, highArg BIGINT, seedArg BIGINT)
RETURNS BIGINT
volatile 
AS $$
	def rndm(lowArg, highArg, seedArg):
		#imports seed and pseudo random
		from random import seed
		from random import random
        # if no argument passed, set to random
		if seedArg is none:
			seedArg = random()
		else:
        	seedArg = seedArg
		seed(seedArg)
		# generate random number
		return random() * (highArg-lowArg +1) + lowArg
	return rndm(lowArg,highArg,seedArg)
$$ LANGUAGE plpythonu;