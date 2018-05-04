tests - at
testAtPathIfAbsent
	"Test the at path if absent method for success and failure modes."

	self assert: (tree atPath: #(1) ifAbsent: [  ]) equals:  firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsent: [  ]) equals:  'One-Two' .
	self assert:  (tree atPath: #(1 three) ifAbsent: [  ]) equals:  'One-Three'.
	self assert: (tree atPath: #(2) ifAbsent: [  ]) equals: 'Two' .
	self assert: (tree atPath: #(2 4) ifAbsent: [ #missing ]) equals:  #missing.
	self
		should: [ (tree atPath: #(1 two three) ifAbsent: [ #missing ]) = #missing ]
		raise: self defaultTestError.
	self should: [ (tree atPath: #(3) ifAbsent: [ #missing ]) = #missing ]