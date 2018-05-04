tests - at
testAtPath
	"Test the at path method for success and failure modes."

	self assert: (tree atPath: #(1)) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three)) equals: 'One-Three'.
	self assert: (tree atPath: #(2)) equals: 'Two'.
	self should: [ tree atPath: #(2 4) ] raise: self defaultTestError.
	self should: [ tree atPath: #(1 two three) ] raise: self defaultTestError.
	self should: [ tree atPath: #(3) ] raise: self defaultTestError