/*
creates a random string of letters for a specified length
based on code from https://pynative.com/python-generate-random-string/
*/
CREATE OR REPLACE function random_jibberish(lenArg INT)
RETURNS CHARACTER VARYING
volatile 
AS $$
	import random
	import string

	letters = string.ascii_lowercase
	return ''.join(random.choice(letters) for i in range(lenArg))

$$ LANGUAGE plpythonu;
