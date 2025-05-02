"
SUnit tests for CTKeyedTree
"
Class {
	#name : #CTKeyedTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'tree',
		'firstLevelOneSubTree'
	],
	#category : 'Containers-KeyedTree-Tests'
}

{ #category : #running }
CTKeyedTreeTest >> setUp [
	super setUp.
	firstLevelOneSubTree := CTKeyedTree new
				at: #two put: 'One-Two';
				at: #three put: 'One-Three';
				yourself.
	tree := CTKeyedTree new
				at: 1 put: firstLevelOneSubTree;
				at: 2 put: 'Two';
				yourself
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> t13 [
	^ CTKeyedTree new
		at: 1 put: '1-3-1';
		at: 2 put: '1-3-2';
		yourself
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> t2 [ 
	^ CTKeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self t13);
				yourself
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> t2AB [
	^ CTKeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self tAB);
				yourself
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> tAB [
	^ CTKeyedTree new
		at: #A put: '1-3-1';
		at: #B put: '1-3-2';
		yourself
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testAllKeys [
	self assert: self t13 allKeys asArray equals: #(1 2).
	self assert: self t2AB allKeys asArray equals: #(1 2 3 #A #B).
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testAllKeysEmptyTree [
	| emptyTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree allKeys isEmpty.
]

{ #category : #'tests - at' }
CTKeyedTreeTest >> testAtPath [
	self assert: (tree atPath: #(1)) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three)) equals: 'One-Three'.
	self assert: (tree atPath: #(2)) equals: 'Two'.
	self should: [ tree atPath: #(2 4) ] raise: self defaultTestError.
	self should: [ tree atPath: #(1 two three) ] raise: self defaultTestError.
	self should: [ tree atPath: #(3) ] raise: self defaultTestError.
]

{ #category : #'tests - at' }
CTKeyedTreeTest >> testAtPathEmpty [
	| emptyTree |
	emptyTree := CTKeyedTree new.
	self should: [ emptyTree atPath: #(1) ] raise: self defaultTestError.
]

{ #category : #tests }
CTKeyedTreeTest >> testAtPathIfAbsent [
	"Test accessing elements using a path with an ifAbsent: block."

	self assert: (tree atPath: #(1) ifAbsent: [ #missing ]) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three) ifAbsent: [ #missing ]) equals: 'One-Three'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: 'Two'.
	self assert: (tree atPath: #(2 4) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree atPath: #(1 two three) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree atPath: #(3) ifAbsent: [ #missing ]) equals: #missing
]

{ #category : #'tests - at' }
CTKeyedTreeTest >> testAtPathIfAbsentPut [
	self assert: (tree atPath: #(1) ifAbsentPut: [ #new ]) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsentPut: [ #new ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three) ifAbsentPut: [ #new ]) equals: 'One-Three'.
	self assert: (tree atPath: #(2) ifAbsentPut: [ #new ]) equals: 'Two'.
	self assert: (tree atPath: #(1 four one) ifAbsentPut: [ #anotherNew ]) equals: #anotherNew.
	self assert: (tree atPath: #(1 four one)) equals: #anotherNew.
	self assert: (tree atPath: #(3) ifAbsentPut: [ #yetAnotherNew ]) equals: #yetAnotherNew.
	self assert: (tree atPath: #(3)) equals: #yetAnotherNew.
	self should: [ tree atPath: #(2 4) ifAbsentPut: [ #new ] ] raise: self defaultTestError.
]

{ #category : #'tests - at' }
CTKeyedTreeTest >> testAtPathPut [
	self assert: (tree atPath: #(1 two) put: #new) equals: #new.
	self assert: (tree atPath: #(1 two)) equals: #new.
	self assert: (tree atPath: #(1 three) put: (firstLevelOneSubTree := CTKeyedTree new)) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 three $1) put: #anotherNew) equals: #anotherNew.
	self assert: (tree atPath: #(1 three $1)) equals: #anotherNew.
	self assert: (tree atPath: #(1 four one) put: #anotherNew) equals: #anotherNew.
	self assert: (tree atPath: #(1 four one)) equals: #anotherNew.
	self should: [ tree atPath: #(2 4) put: [ #new ] ] raise: self defaultTestError.
]

{ #category : #'tests - copying' }
CTKeyedTreeTest >> testCopy [
	| c t2 t3 |
	tree := CTKeyedTree new
		at: 1 put: (t2 := CTKeyedTree new
			at: #two put: 'One-Two';
			at: #three put: 'One-Three';
			at: #four put: (t3 := CTKeyedTree new);
			yourself);
		at: 2 put: 'Two';
		yourself.
	c := tree copy.
	self assert: c = tree.
	self deny: c == tree.
	self assert: (c at: 1) = t2.
	self deny: (c at: 1) == t2.
	self assert: (c atPath: #(1 four)) = t3.
	self deny: (c atPath: #(1 four)) == t3.
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testFormattedText [
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
'.
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testMerge [
	| t1 t2 t13 m subT1 subt11 wrapSubt11 |
	t13 := self t13.
	subT1 := self t2.
	subt11 := CTKeyedTree new
		at: 1 put: '1-1-1';
		at: 2 put: '1-1-2';
		yourself.
	wrapSubt11 := CTKeyedTree new
		at: 1 put: subt11;
		at: 2 put: '1-2*';
		yourself.
	t1 := CTKeyedTree new
		at: 1 put: subT1;
		at: 2 put: '2';
		yourself.
	t2 := CTKeyedTree new
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
	self assert: (m atPath: #(1 3 2)) equals: '1-3-2'.
]

{ #category : #'tests - copying' }
CTKeyedTreeTest >> testPostCopy [
	| original copy subTree |
	original := CTKeyedTree new
		at: 1 put: (subTree := CTKeyedTree new at: #a put: 'A'; yourself);
		at: 2 put: 'B';
		yourself.
	copy := original copy.
	"Modify the copy and ensure the original is unaffected"
	(copy at: 1) at: #a put: 'Modified'.
	self assert: (copy atPath: #(1 a)) equals: 'Modified'.
	self assert: (original atPath: #(1 a)) equals: 'A'.
	self deny: (copy at: 1) == subTree.
]

{ #category : #tests }
CTKeyedTreeTest >> testPutFormattedTextOnLevelIndentString [
	"Test formatted text output with a custom indent string."

	| stream |
	stream := String new writeStream.
	tree putFormattedTextOn: stream level: 1 indentString: '>>'.
	self
		assert: stream contents
		equals:
			'>>1
>>  #three : ''One-Three''
>>  #two : ''One-Two''
>>2 : ''Two''
'
]

{ #category : #'tests - removing' }
CTKeyedTreeTest >> testRemovePath [
	self should: [ tree removePath: #(4) ] raise: self defaultTestError.
	self should: [ tree removePath: #(1 one) ] raise: self defaultTestError.
	self assert: (tree removePath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree removePath: #(2)) equals: 'Two'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: #missing.
]

{ #category : #'tests - removing' }
CTKeyedTreeTest >> testRemovePathIfAbsent [
	self assert: (tree removePath: #(4) ifAbsent: [ #none ]) equals: #none.
	self assert: (tree removePath: #(1 2 3 4) ifAbsent: [ #none ]) equals: #none.
	self assert: (tree removePath: #(1 two) ifAbsent: [ #none ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree removePath: #(2) ifAbsent: [ #none ]) equals: 'Two'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: #missing.
]

{ #category : #tests }
CTKeyedTreeTest >> testSortBlock [
	"Test the sort block for keys."

	| treeWithMixedKeys sortedKeys |
	treeWithMixedKeys := CTKeyedTree new
		at: 2 put: 'Two';
		at: #a put: 'A';
		at: 1 put: 'One';
		yourself.
	sortedKeys := treeWithMixedKeys keys asSortedCollection: treeWithMixedKeys sortBlock.
	self assert: sortedKeys asArray equals: #(#a 1 2)
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testSubtrees [
	| t1 t2 t3 t4 |
	t2 := self t2.
	t3 := self t13.
	t1 := CTKeyedTree new
		at: 1 put: t2;
		at: 2 put: '2';
		at: 3 put: (t4 := self t13);
		yourself.
	self assert: t1 subtrees equals: {t2. t4}.
	self assert: (t1 at: 1) subtrees equals: {t3}.
]

{ #category : #'tests - operation' }
CTKeyedTreeTest >> testSubtreesEmpty [
	| emptyTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree subtrees isEmpty.
]