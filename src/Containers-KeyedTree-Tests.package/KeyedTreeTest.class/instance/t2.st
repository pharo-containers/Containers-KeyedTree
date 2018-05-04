tests - operation
t2 

	^ KeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self t13);
				yourself