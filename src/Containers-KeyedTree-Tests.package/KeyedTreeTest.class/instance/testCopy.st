tests - at
testCopy
	"Test the copy method for success and failure modes."

	| c t2 t3 |
	tree := KeyedTree new
		at: 1
			put:
			(t2 := KeyedTree new
				at: #two put: 'One-Two';
				at: #three put: 'One-Three';
				at: #four put: (t3 := KeyedTree new);
				yourself);
		at: 2 put: 'Two';
		yourself.
	c := tree copy.
	self assert:  c = tree .
	self deny:  c == tree .
	self assert:  (c at: 1) = t2 .
	self deny:  (c at: 1) == t2 .
	self assert:  (c atPath: #(1 four)) = t3 .
	self deny:  (c atPath: #(1 four)) == t3 