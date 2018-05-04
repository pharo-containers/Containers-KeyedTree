tests - at
testAtPathIfAbsentPut
	"Test the at path if absent put method for success and failure modes."

	self assert: (tree atPath: #(1) ifAbsentPut: [ #new ]) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsentPut: [ #new ]) equals: 'One-Two' .
	self assert: (tree atPath: #(1 three) ifAbsentPut: [ #new ]) equals: 'One-Three'.
	self assert: (tree atPath: #(2) ifAbsentPut: [ #new ]) equals: 'Two'.
	self
		should: [ tree atPath: #(2 4) ifAbsentPut: [ #new ] ]
		raise: self defaultTestError.
	self
		should: [ tree atPath: #(1 two three) ifAbsentPut: [ #new ] ]
		raise: self defaultTestError.
	self
		should: [ (tree atPath: #(1 four one) ifAbsentPut: [ #anotherNew ]) = #anotherNew ].
	self should: [ (tree atPath: #(1 four one)) = #anotherNew ].
	self
		should: [ (tree atPath: #(3) ifAbsentPut: [ #yetAnotherNew ]) = #yetAnotherNew ].
	self should: [ (tree atPath: #(3)) = #yetAnotherNew ]