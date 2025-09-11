"
I test the KeyedTree implementation (CTKeyedTree).

I verify correctness of all tree operations including path-based access, tree merging, collection protocol methods, and edge cases like empty trees, invalid paths, and complex hierarchical structures.

I ensure the KeyedTree maintains proper hierarchical structure and handles various data types correctly.
"
Class {
	#name : 'CTKeyedTreeTest',
	#superclass : 'TestCase',
	#instVars : [
		'tree',
		'firstLevelOneSubTree'
	],
	#category : 'Containers-KeyedTree-Tests',
	#package : 'Containers-KeyedTree-Tests'
}

{ #category : 'running' }
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

{ #category : 'helpers' }
CTKeyedTreeTest >> t13 [

	^ CTKeyedTree new
		at: 1 put: '1-3-1';
		at: 2 put: '1-3-2';
		yourself
]

{ #category : 'helpers' }
CTKeyedTreeTest >> t2 [ 
	^ CTKeyedTree new
				at: 1 put: '1-1';
				at: 2 put: '1-2';
				at: 3 put: (self t13);
				yourself
]

{ #category : 'helpers' }
CTKeyedTreeTest >> t2AB [

	^ CTKeyedTree new
		at: 1 put: '1-1';
		at: 2 put: '1-2';
		at: 3 put: (CTKeyedTree new
			at: #A put: '1-3-1';
			at: #B put: '1-3-2';
			yourself);
		yourself
]

{ #category : 'helpers' }
CTKeyedTreeTest >> tAB [
	^ CTKeyedTree new
		at: #A put: '1-3-1';
		at: #B put: '1-3-2';
		yourself
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAddMultipleElements [

	tree := CTKeyedTree new.
	tree at: #key1 put: 'value1'.
	tree at: #key2 put: 'value2'.
	tree at: #key3 put: 'value3'.
	
	self assert: tree size equals: 3
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAddSingleElement [

	| emptyTree |
	emptyTree := CTKeyedTree new.
	emptyTree at: #test put: 'value'.
	
	self deny: emptyTree isEmpty.
	self assert: emptyTree size equals: 1
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAllKeys [

	self assert: self t13 allKeys asArray equals: #(1 2).
	self assert: self t2AB allKeys asArray equals: #(1 2 3 #A #B).
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAllPaths [

	| paths |
	paths := self t2AB allPaths.
	self assert: paths size equals: 4.
	self assert: (paths includes: #(1)).
	self assert: (paths includes: #(2)).
	self assert: (paths includes: #(3 #A)).
	self assert: (paths includes: #(3 #B)).
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAsArray [

	| result |
	result := self t13 asArray.
	self assert: result size equals: 2.
	self assert: (result includes: '1-3-1').
	self assert: (result includes: '1-3-2').
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAtPath [

	self assert: (tree atPath: #(1)) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three)) equals: 'One-Three'.
	self assert: (tree atPath: #(2)) equals: 'Two'.
	
	self should: [ tree atPath: #(2 4) ] raise: KeyNotFound.
	self should: [ tree atPath: #(1 two three) ] raise: KeyNotFound.
	self should: [ tree atPath: #(3) ] raise: KeyNotFound.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAtPathIfAbsent [

	self assert: (tree atPath: #(1) ifAbsent: [ #missing ]) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three) ifAbsent: [ #missing ]) equals: 'One-Three'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: 'Two'.
	self assert: (tree atPath: #(2 4) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree atPath: #(1 two three) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree atPath: #(3) ifAbsent: [ #missing ]) equals: #missing
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAtPathIfAbsentPut [

	self assert: (tree atPath: #(1) ifAbsentPut: [ #new ]) equals: firstLevelOneSubTree.
	self assert: (tree atPath: #(1 two) ifAbsentPut: [ #new ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 three) ifAbsentPut: [ #new ]) equals: 'One-Three'.
	self assert: (tree atPath: #(2) ifAbsentPut: [ #new ]) equals: 'Two'.
	self assert: (tree atPath: #(1 four one) ifAbsentPut: [ #anotherNew ]) equals: #anotherNew.
	self assert: (tree atPath: #(1 four one)) equals: #anotherNew.
	self assert: (tree atPath: #(3) ifAbsentPut: [ #yetAnotherNew ]) equals: #yetAnotherNew.
	self assert: (tree atPath: #(3)) equals: #yetAnotherNew.
	
	self should: [ tree atPath: #(2 4) ifAbsentPut: [ #new ] ] raise: MessageNotUnderstood.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testAtPathPut [

	self assert: (tree atPath: #( 1 two ) put: #new) equals: #new.
	self assert: (tree atPath: #( 1 two )) equals: #new.
	self
		assert: (tree atPath: #( 1 three ) put: CTKeyedTree new) class
		equals: CTKeyedTree.
	self
		assert: (tree atPath: #( 1 four one ) put: #anotherNew)
		equals: #anotherNew.
	self assert: (tree atPath: #( 1 four one )) equals: #anotherNew.

	self should: [ tree atPath: #(2 4) put: #new ] raise: KeyNotFound.

]

{ #category : 'tests' }
CTKeyedTreeTest >> testCollectionMethods [

	| doubled selected found |
	tree at: #color put: 'red'.
	tree at: #number put: 42.
	
	doubled := self t13 collect: [ :value | value, '-modified' ].
	self assert: (doubled at: 1) equals: '1-3-1-modified'.
	self assert: (doubled at: 2) equals: '1-3-2-modified'.
	
	selected := tree select: [ :value | value isString ].
	self assert: (selected at: #color) equals: 'red'.
	self assert: (selected at: 2) equals: 'Two'.
	self deny: (selected includesKey: #number).
	
	found := tree detect: [ :value | value = 'red' ] ifNone: [ nil ].
	self assert: found equals: 'red'.
	
	self assert: (tree anySatisfy: [ :value | value = 'red' ]).
	self deny: (tree anySatisfy: [ :value | value = 'nonexistent' ])
]

{ #category : 'tests' }
CTKeyedTreeTest >> testCopy [

	| c |
	c := tree copy.
	self assert: c = tree.
	self deny: c == tree.
	self assert: (c at: 1) equals: (tree at: 1).
	self deny: (c at: 1) == (tree at: 1).

	c at: #new put: 'newValue'.
	self deny: (tree includesKey: #new).
	self assert: (c includesKey: #new)
]

{ #category : 'tests' }
CTKeyedTreeTest >> testDepth [

	| emptyTree simpleTree deepTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree depth equals: 0.
	
	simpleTree := CTKeyedTree new at: #key put: 'value'; yourself.
	self assert: simpleTree depth equals: 1.
	
	deepTree := CTKeyedTree new
		at: #level1 put: (CTKeyedTree new
			at: #level2 put: (CTKeyedTree new
				at: #level3 put: 'deep value';
				yourself);
			yourself);
		yourself.
	self assert: deepTree depth equals: 3.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testDoMethod [
	
	| result |
	result := OrderedCollection new.
	self t13 do: [ :value | result add: value ].
	
	self assert: result size equals: 2.
	self assert: (result includes: '1-3-1').
	self assert: (result includes: '1-3-2').
]

{ #category : 'tests' }
CTKeyedTreeTest >> testEmpty [

	| emptyTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree isEmpty.
	self assert: emptyTree size equals: 0.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testEmptyTreeOperations [

	| emptyTree result |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree isEmpty.
	self assert: emptyTree allKeys isEmpty.
	self assert: emptyTree subtrees isEmpty.
	self deny: (emptyTree includesPath: #(nonexistent)).
	
	result := emptyTree collect: [ :value | value ].
	self assert: result isEmpty.
	
	self deny: (emptyTree anySatisfy: [ :value | true ])
]

{ #category : 'tests' }
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

{ #category : 'tests' }
CTKeyedTreeTest >> testHasPath [

	self assert: (tree hasPath: #(1)).
	self assert: (tree hasPath: #(1 two)).
	self assert: (tree hasPath: #(2)).
	self deny: (tree hasPath: #(3)).
	self deny: (tree hasPath: #(1 four)).
	self deny: (tree hasPath: #(2 nested)).
]

{ #category : 'tests' }
CTKeyedTreeTest >> testIncludesPath [

	self assert: (tree includesPath: #(1 two)).
	self deny: (tree includesPath: #(nonexistent path)).
]

{ #category : 'tests' }
CTKeyedTreeTest >> testLeafValues [

	| leaves |
	leaves := self t2AB leafValues.
	self assert: leaves size equals: 4.
	self assert: (leaves includes: '1-1').
	self assert: (leaves includes: '1-2').
	self assert: (leaves includes: '1-3-1').
	self assert: (leaves includes: '1-3-2').
]

{ #category : 'tests' }
CTKeyedTreeTest >> testMerge [

	| t1 t2 m |
	t1 := CTKeyedTree new
		at: 1 put: 'original';
		at: #shared put: (CTKeyedTree new
			at: #key1 put: 'value1';
			at: #key2 put: 'value2';
			yourself);
		yourself.
	
	t2 := CTKeyedTree new
		at: 2 put: 'new';
		at: #shared put: (CTKeyedTree new
			at: #key2 put: 'updated';
			at: #key3 put: 'value3';
			yourself);
		yourself.
	
	m := t1 copy merge: t2.
	self assert: (m at: 1) equals: 'original'.
	self assert: (m at: 2) equals: 'new'.
	self assert: (m atPath: #(shared key1)) equals: 'value1'.
	self assert: (m atPath: #(shared key2)) equals: 'updated'.
	self assert: (m atPath: #(shared key3)) equals: 'value3'.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testNodeCount [

	| emptyTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree nodeCount equals: 0.
	
	self assert: self t13 nodeCount equals: 2.
	self assert: self t2AB nodeCount equals: 5. "3 direct + 2 in subtree"
	self assert: tree nodeCount equals: 4. "2 direct + 2 in subtree"
]

{ #category : 'tests' }
CTKeyedTreeTest >> testPathOf [

		| path |
	path := tree pathOf: 'One-Two'.
	self assert: path equals: #(1 two).
	
	path := tree pathOf: 'Two'.
	self assert: path equals: #(2).
	
	path := tree pathOf: 'nonexistent'.
	self assert: path isNil.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testRemovePath [

	self should: [ tree removePath: #(4) ] raise: KeyNotFound.
	self should: [ tree removePath: #(1 one) ] raise: KeyNotFound.
	
	self assert: (tree removePath: #(1 two)) equals: 'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree removePath: #(2)) equals: 'Two'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: #missing.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testRemovePathIfAbsent [

	self assert: (tree removePath: #(4) ifAbsent: [ #none ]) equals: #none.
	self assert: (tree removePath: #(1 2 3 4) ifAbsent: [ #none ]) equals: #none.
	self assert: (tree removePath: #(1 two) ifAbsent: [ #none ]) equals: 'One-Two'.
	self assert: (tree atPath: #(1 two) ifAbsent: [ #missing ]) equals: #missing.
	self assert: (tree removePath: #(2) ifAbsent: [ #none ]) equals: 'Two'.
	self assert: (tree atPath: #(2) ifAbsent: [ #missing ]) equals: #missing.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testSortBlock [

	| treeWithMixedKeys sortedKeys |
	treeWithMixedKeys := CTKeyedTree new
		at: 2 put: 'Two';
		at: #a put: 'A';
		at: 1 put: 'One';
		yourself.
	sortedKeys := treeWithMixedKeys keys asSortedCollection: treeWithMixedKeys sortBlock.
	self assert: sortedKeys asArray equals: #(#a 1 2)
]

{ #category : 'tests' }
CTKeyedTreeTest >> testSubtrees [

		| subtreeList |
	subtreeList := tree subtrees.
	self assert: subtreeList size equals: 1.
	self assert: (subtreeList includes: firstLevelOneSubTree).
	
	self assert: self t13 subtrees isEmpty.
	self assert: self t2AB subtrees size equals: 1.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testSubtreesEmpty [
	| emptyTree |
	emptyTree := CTKeyedTree new.
	self assert: emptyTree subtrees isEmpty.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testTreeProperties [

	self assert: CTKeyedTree new treeDepth equals: 0.
	self assert: self t13 treeDepth equals: 1.
	self assert: self t2AB treeDepth equals: 2.
	self assert: tree treeDepth equals: 2.
	
	self assert: CTKeyedTree new treeSize equals: 0.
	self assert: self t13 treeSize equals: 2.
	self assert: tree treeSize equals: 3.
]

{ #category : 'tests' }
CTKeyedTreeTest >> testTypeConsistency [

	| mixedTree |
	mixedTree := CTKeyedTree new
		at: 'string' put: 'value';
		at: 42 put: 'number';
		at: #symbol put: 'symbol';
		at: $a put: 'character';
		yourself.
	
	self assert: (mixedTree at: 'string') equals: 'value'.
	self assert: (mixedTree at: 42) equals: 'number'.
	self assert: (mixedTree at: #symbol) equals: 'symbol'.
	self assert: (mixedTree at: $a) equals: 'character'.
]
