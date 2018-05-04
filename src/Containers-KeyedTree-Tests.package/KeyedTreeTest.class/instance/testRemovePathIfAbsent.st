tests - remove
testRemovePathIfAbsent
	"Test the remove path if absent method for success and failure modes."

	self assert:  (tree removePath: #(4) ifAbsent:  [#none ]) equals: #none .
	self assert:  (tree removePath: #(1 2 3 4) ifAbsent:  [#none ]) equals: #none .
	self assert:  (tree removePath: #(1 two) ifAbsent:  [#none ]) equals: 'One-Two' .
	self assert:  (tree atPath: #(1 two) ifAbsent: [  ]  ) equals: nil .
	self assert:  (tree removePath: #(2) ifAbsent:  [#none ]) equals: 'Two' .
	self assert:  (tree atPath: #(2) ifAbsent:  [  ]) equals: nil 