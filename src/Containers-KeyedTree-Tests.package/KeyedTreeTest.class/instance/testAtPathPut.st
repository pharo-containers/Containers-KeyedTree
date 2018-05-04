tests - at
testAtPathPut
	"Test the at path put method for success and failure modes."

	self assert: (tree atPath: #(1 two) put: #new) equals: #new.
	self assert: (tree atPath: #(1 two)) equals: #new.
	self
		assert:  (tree atPath: #(1 three) put: (firstLevelOneSubTree := KeyedTree new))
		equals: firstLevelOneSubTree .
	self assert: (tree atPath: #(1 three $1) put: #anotherNew) equals: #anotherNew.
	self assert: (tree atPath: #(1 three $1)) equals: #anotherNew.
	self should: [ tree atPath: #(2 4) put: [ #new ] ] raise: self defaultTestError.
	self assert:  (tree atPath: #(1 four one) put: #anotherNew) equals: #anotherNew.
	self assert: (tree atPath: #(1 four one)) equals: #anotherNew 