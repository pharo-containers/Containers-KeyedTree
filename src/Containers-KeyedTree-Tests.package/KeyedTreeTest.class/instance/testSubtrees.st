tests - operation
testSubtrees
	"Test the subtrees method for success and failure modes."

	| t1 t2 t3 t4 |
	t2 := self t2.
	t3 := self t13.
	t1 := KeyedTree new
		at: 1 put: t2;
		at: 2 put: '2';
		at: 3 put: (t4 := self t13);
		yourself.
	self
		assert: t1 subtrees
		equals:
			{t2.
			t4}.
	self assert: (t1 at: 1) subtrees equals: {t3}