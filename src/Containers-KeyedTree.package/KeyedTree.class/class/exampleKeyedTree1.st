samples
exampleKeyedTree1
	<sampleInstance>

	^ KeyedTree new
		at: 1 put: 'One';
		at: 2 put: 'Two';
		at: 'Tree'
			put:
			(KeyedTree new
				at: $a put: 'Tree-A';
				at: $b put: 'Tree-B';
				yourself);
		yourself