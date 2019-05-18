"
SUnit tests for keyed trees
"
Class {
	#name : #KeyedTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'tree',
		'firstLevelOneSubTree'
	],
	#category : 'Containers-KeyedTree-Tests'
}

{ #category : #running }
KeyedTreeTest >> setUp [
	super setUp.
	firstLevelOneSubTree := KeyedTree new
				at: #two put: 'One-Two';
				at: #three put: 'One-Three';
				yourself.
	tree := KeyedTree new
				at: 1 put: firstLevelOneSubTree;
				at: 2 put: 'Two';
				yourself
]

{ #category : #'tests - operation' }
KeyedTreeTest >> t13 [
	^ KeyedTree new
		at: 1 put: '1-3-1';
		at: 2 put: '1-3-2';
		yourself
]

{ #category : #'tests - operation' }
KeyedTreeTest >> t2 [ 

	^ KeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self t13);
				yourself
]

{ #category : #'tests - operation' }
KeyedTreeTest >> t2AB [

	^ KeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self tAB);
				yourself
]

{ #category : #'tests - operation' }
KeyedTreeTest >> tAB [
	^ KeyedTree new
		at: #A put: '1-3-1';
		at: #B put: '1-3-2';
		yourself
]

{ #category : #'tests - operation' }
KeyedTreeTest >> testAllKeys [
	
	self assert: self t13 allKeys asArray equals: #(1 2).
	self assert: self t2AB allKeys asArray equals: #(1 2 3 #A #B).
]

{ #category : #'tests - at' }
KeyedTreeTest >> testAtPath [
	"Test the at path method for success and failure modes."

	self assert: (tree atPath: #(1)) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three)) equals: 'One-Three'.
	self assert: (tree atPath: #(2)) equals: 'Two'.
	self should: [ tree atPath: #(2 4) ] raise: self defaultTestError.
	self should: [ tree atPath: #(1 two three) ] raise: self defaultTestError.
	self should: [ tree atPath: #(3) ] raise: self defaultTestError
]

{ #category : #'tests - at' }
KeyedTreeTest >> testAtPathIfAbsent [
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
]

{ #category : #'tests - at' }
KeyedTreeTest >> testAtPathIfAbsentPut [
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
]

{ #category : #'tests - at' }
KeyedTreeTest >> testAtPathPut [
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
]

{ #category : #'tests - at' }
KeyedTreeTest >> testCopy [
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
]

{ #category : #'tests - operation' }
KeyedTreeTest >> testFormattedText [
	
	self assert: self t13 formattedText equals: 
'1 : ''1-3-1''
2 : ''1-3-2''
'.
	self assert: self t2AB formattedText equals: 
'1 : ''1-1''
2 : ''1-2''
3
  #A : ''1-3-1''
  #B : ''1-3-2''
'
]

{ #category : #'tests - operation' }
KeyedTreeTest >> testMerge [
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
]

{ #category : #'tests - remove' }
KeyedTreeTest >> testRemovePath [
	"Test the remove path method for success and failure modes."

	self should: [ tree removePath: #(4) ] raise: self defaultTestError.
	self should: [ tree removePath: #(1 one) ] raise: self defaultTestError.
	self assert: (tree removePath: #(1 two)) equals:  'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [  ]) equals: nil.
	self assert: (tree removePath: #(2)) equals: 'Two' .
	self assert: (tree atPath: #(2) ifAbsent: [  ]) equals: nil
]

{ #category : #'tests - remove' }
KeyedTreeTest >> testRemovePathIfAbsent [
	"Test the remove path if absent method for success and failure modes."

	self assert:  (tree removePath: #(4) ifAbsent:  [#none ]) equals: #none .
	self assert:  (tree removePath: #(1 2 3 4) ifAbsent:  [#none ]) equals: #none .
	self assert:  (tree removePath: #(1 two) ifAbsent:  [#none ]) equals: 'One-Two' .
	self assert:  (tree atPath: #(1 two) ifAbsent: [  ]  ) equals: nil .
	self assert:  (tree removePath: #(2) ifAbsent:  [#none ]) equals: 'Two' .
	self assert:  (tree atPath: #(2) ifAbsent:  [  ]) equals: nil 
]

{ #category : #'tests - operation' }
KeyedTreeTest >> testSubtrees [
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
]
