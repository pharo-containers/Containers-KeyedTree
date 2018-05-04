tests - remove
testRemovePath
	"Test the remove path method for success and failure modes."

	self should: [ tree removePath: #(4) ] raise: self defaultTestError.
	self should: [ tree removePath: #(1 one) ] raise: self defaultTestError.
	self assert: (tree removePath: #(1 two)) equals:  'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [  ]) equals: nil.
	self assert: (tree removePath: #(2)) equals: 'Two' .
	self assert: (tree atPath: #(2) ifAbsent: [  ]) equals: nil