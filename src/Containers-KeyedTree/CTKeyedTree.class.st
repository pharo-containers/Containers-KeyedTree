"
I'm a special kind of dictionary. I provide path-based access to elements contained in the receiver and any subtrees.

Example:

[[[
(CTKeyedTree new
	at: 1 put: 'One';
	at: 2 put: 'Two';
	at: 'Tree' put: (CTKeyedTree new
					at: $a put: 'Tree-A';
					at: $b put: 'Tree-B';
					yourself);
	yourself) atPath: #('Tree' $b)
>>> 'Tree-B'
]]]
"
Class {
	#name : #CTKeyedTree,
	#superclass : #Dictionary,
	#category : 'Containers-KeyedTree'
}

{ #category : #samples }
CTKeyedTree class >> exampleKeyedTree1 [
	<sampleInstance>
	^ CTKeyedTree new
		at: 1 put: 'One';
		at: 2 put: 'Two';
		at: 'Tree'
			put:
			(CTKeyedTree new
				at: $a put: 'Tree-A';
				at: $b put: 'Tree-B';
				yourself);
		yourself
]

{ #category : #accessing }
CTKeyedTree >> allKeys [
	"Answer an ordered collection of the keys of the receiver and any subtrees. Please no circular references!"
	| answer |
	answer := OrderedCollection new.
	answer addAll: self keys.
	self subtrees do: [ :t | answer addAll: t allKeys ].
	^ answer
]

{ #category : #accessing }
CTKeyedTree >> atPath: anArray [
	"Answer the element referenced by the given key path. Signal an error if not found."
	^ self atPath: anArray ifAbsent: [ self errorKeyNotFound: anArray ]
]

{ #category : #accessing }
CTKeyedTree >> atPath: anArray ifAbsent: aBlock [
	| element |
	element := self.
	anArray do: [ :key | 
		(element isKindOf: self class)
			ifTrue: [ element := element at: key ifAbsent: [ ^aBlock value ] ]
			ifFalse: [ ^aBlock value ] ].
	^ element
]

{ #category : #accessing }
CTKeyedTree >> atPath: anArray ifAbsentPut: aBlock [
	"Answer the element referenced by the given key path. Answer the value of aBlock if not found after creating its path."
	| element |
	anArray isEmpty ifTrue: [ ^self ].
	element := self.
	anArray allButLastDo: [ :key | element := element at: key ifAbsentPut: [ self species new ] ].
	^ element at: anArray last ifAbsentPut: aBlock
]

{ #category : #accessing }
CTKeyedTree >> atPath: anArray put: aBlock [
	"Answer the value of aBlock after creating its path."
	| element |
	anArray isEmpty ifTrue: [ ^self ].
	element := self.
	anArray allButLastDo: [ :key | element := element at: key ifAbsentPut: [ self species new ] ].
	^ element at: anArray last put: aBlock
]

{ #category : #printing }
CTKeyedTree >> formattedText [
	"Answer a string or text representing the receiver with indentation and, possibly, markup."
	^ String new writeStreamDo: [ :str | 
		self putFormattedTextOn: str level: 0 indentString: '  '.
		str contents ]
]

{ #category : #adding }
CTKeyedTree >> merge: aKeyedTree [
	"Merge the given tree into the receiver, overwriting or extending elements as needed."
	aKeyedTree keysAndValuesDo: [ :k :v | 
		| subtree |
		(v isKindOf: CTKeyedTree)
			ifTrue: [ 
				subtree := self at: k ifAbsentPut: [ v species new ].
				(subtree isKindOf: CTKeyedTree)
					ifFalse: [ subtree := self at: k put: v species new ].
				subtree merge: v ]
			ifFalse: [ self at: k put: v ] ]
]

{ #category : #copying }
CTKeyedTree >> postCopy [
	"Must copy the associations, or later store will affect both the original and the copy. Copy any subtrees too!"
	array := array collect: [ :assoc |
		assoc ifNil: [ nil ]
			ifNotNil: [ Association
				key: assoc key
				value: ((assoc value isKindOf: CTKeyedTree)
					ifTrue: [ assoc value copy ]
					ifFalse: [ assoc value ]) ] ]
]

{ #category : #printing }
CTKeyedTree >> putFormattedTextOn: aStream level: indentLevel indentString: aString [
	"Write a textual representation of the receiver to aStream, indenting to indentLevel using aString as the indent string."

	(self keys asSortedCollection: self sortBlock)
		do: [ :k | 
			| v |
			indentLevel = 0
				ifFalse: [ 
					indentLevel = 1
						ifTrue: [ aStream nextPutAll: aString ]
						ifFalse: [ indentLevel - 1 timesRepeat: [ aStream nextPutAll: aString ]. aStream nextPutAll: '  ' ] ].
			aStream nextPutAll: k printString.
			v := self at: k.
			(v isKindOf: self class)
				ifTrue: [ aStream cr.
					v putFormattedTextOn: aStream level: indentLevel + 1 indentString: aString ]
				ifFalse: [ aStream
						nextPutAll: ' : ';
						nextPutAll: v printString.
					aStream cr ] ]
]

{ #category : #removing }
CTKeyedTree >> removePath: anArray [
	"Remove and answer the element referenced by the given path. Signal an error if not found."
	^ self removePath: anArray ifAbsent: [ self errorKeyNotFound: anArray ]
]

{ #category : #removing }
CTKeyedTree >> removePath: anArray ifAbsent: aBlock [
	"Remove and answer the element referenced by the given path. Answer the value of aBlock if not found."
	| element |
	anArray isEmpty ifTrue: [ ^self ].
	element := self.
	anArray allButLastDo: [ :key | element := element at: key ifAbsent: [ ^aBlock value ] ].
	^ element removeKey: anArray last ifAbsent: aBlock	
]

{ #category : #accessing }
CTKeyedTree >> sortBlock [
	"Answer a sort block that can be used to sort the keys of the receiver."

	^ [ :a :b | 
		a class = b class 
			ifTrue: [ a <= b ]
			ifFalse: [ 
				(a isSymbol and: [ b isNumber ]) 
					ifTrue: [ true ] 
					ifFalse: [ 
						(b isSymbol and: [ a isNumber ]) 
							ifTrue: [ false ] 
							ifFalse: [ a class name <= b class name ] ] ] ]
]

{ #category : #accessing }
CTKeyedTree >> subtrees [
	"Answer the subtrees of the receiver."
	^ (self select: [ :v | v isKindOf: CTKeyedTree ]) values
]

{ #category : #tests }
CTKeyedTreeTest >> testFormattedText [
	"Test the formatted text representation of the tree."

	self assert: self t13 formattedText equals:
		'1 : ''1-3-1''
2 : ''1-3-2''
'
]