tests - at
setUp
	
	firstLevelOneSubTree := KeyedTree new
				at: #two put: 'One-Two';
				at: #three put: 'One-Three';
				yourself.
	tree := KeyedTree new
				at: 1 put: firstLevelOneSubTree;
				at: 2 put: 'Two';
				yourself