tests - operation
testMerge
	"Test the merge method for success and failure modes."

	| t1 t2 t13 m subT1 subt11 wrapSubt11 |
	t13 := self t13.
	subT1 := self t2.
	subt11 := KeyedTree new
		at: 1 put: '1-1-1';
		at: 2 put: '1-1-2';
		yourself.
	wrapSubt11 := KeyedTree new
		at: 1 put: subt11;
		at: 2 put: '1-2*';
		yourself.
	t1 := KeyedTree new
		at: 1 put: subT1;
		at: 2 put: '2';
		yourself.
	t2 := KeyedTree new
		at: 1 put: wrapSubt11;
		at: 3 put: '3';
		yourself.
	m := t1 merge: t2.
	self assert: (m at: 2) equals: '2'.
	self assert: (m at: 3) equals: '3'.
	self assert: (m atPath: #(1 2)) equals: '1-2*'.
	self assert: (m atPath: #(1 1 1)) equals: '1-1-1'.
	self assert: (m atPath: #(1 1 2)) equals: '1-1-2'.
	self assert: (m atPath: #(1 3 1)) equals: '1-3-1'.
	self assert: (m atPath: #(1 3 2)) equals: '1-3-2'