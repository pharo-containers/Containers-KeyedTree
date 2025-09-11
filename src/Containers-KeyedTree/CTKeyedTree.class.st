"
I represent a hierarchical data structure that provides path-based access to nested elements with dictionary-like functionality.

I extend Dictionary behavior to support tree-like structures where values can be accessed through paths represented as arrays of keys. Each node can contain both direct values and subtrees, enabling hierarchical data organization similar to file systems or nested configurations.

I am ideal for configuration management, file system representations, menu systems, and any scenario requiring structured hierarchical data with efficient path-based operations.

Key features:
- Path-based access using arrays of keys: atPath: #(level1 level2 key)
- Automatic subtree creation when needed
- Intelligent merging of tree structures  
- Safe access with flexible conditional blocks
- All standard Dictionary operations plus tree-specific methods
- Full Collection protocol implementation

Example:
    tree := CTKeyedTree new
        at: #config put: (CTKeyedTree new 
            at: #database put: (CTKeyedTree new
                at: #host put: 'localhost';
                at: #port put: 5432;
                yourself);
            yourself);
        at: #appName put: 'MyApp';
        yourself.
    tree atPath: #(config database host). => 'localhost'
    tree atPath: #(config database port). => 5432
"
Class {
	#name : 'CTKeyedTree',
	#superclass : 'Dictionary',
	#category : 'Containers-KeyedTree',
	#package : 'Containers-KeyedTree'
}

{ #category : 'examples' }
CTKeyedTree class >> exampleConfiguration [

	<sampleInstance>
	^ self class new
		  at: #database put: (self class new
				   at: #host put: 'localhost';
				   at: #port put: 5432;
				   at: #ssl put: true;
				   yourself);
		  at: #cache put: (self class new
			   at: #type put: 'redis';
			   at: #host put: 'cache.local';
			   at: #timeout put: 5000;
			   yourself);
		  at: #appName put: 'SampleApp';
		  at: #version put: '1.2.0';
		  yourself
]

{ #category : 'examples' }
CTKeyedTree class >> exampleFileSystemTree [

		<sampleInstance>
	^ self class new
		at: #home put: (self class new
			at: #user put: (self class new
				at: #documents put: (self class new
					at: 'report.pdf' put: 'PDF Document';
					at: 'notes.txt' put: 'Text File';
					yourself);
				at: #downloads put: (self class new
					at: 'installer.dmg' put: 'Disk Image';
					yourself);
				yourself);
			yourself);
		at: #etc put: (self class new
			at: 'config.json' put: 'Configuration File';
			yourself);
		yourself
]

{ #category : 'examples' }
CTKeyedTree class >> exampleMenuSystem [

	"Example of using KeyedTree for hierarchical menu structures"
	<sampleInstance>
	^ self class new
		at: #file put: (self class new
			at: #new put: 'Create New File';
			at: #open put: 'Open File';
			at: #recent put: (self class new
				at: #file1 put: 'recent1.txt';
				at: #file2 put: 'recent2.txt';
				yourself);
			yourself);
		at: #edit put: (self class new
			at: #copy put: 'Copy';
			at: #paste put: 'Paste';
			yourself);
		yourself
]

{ #category : 'accessing' }
CTKeyedTree >> allKeys [

	"Answer an ordered collection containing all keys from this tree and its subtrees."
	
	| result |
	result := OrderedCollection new.
	result addAll: self keys.
	self subtrees do: [ :subtree | 
		result addAll: subtree allKeys ].
	^ result
]

{ #category : 'accessing' }
CTKeyedTree >> allPaths [

	"Answer all possible paths in this tree as an array of path arrays.
	Each path leads to a leaf value (non-tree value)."
	
	| paths |
	paths := OrderedCollection new.
	self allPathsStartingWith: #() into: paths.
	^ paths asArray
]

{ #category : 'private' }
CTKeyedTree >> allPathsStartingWith: pathPrefix into: aCollection [

	"Private method to recursively collect all paths starting with the given prefix"
	
	self keysAndValuesDo: [ :key :value |
		| currentPath |
		currentPath := pathPrefix copyWith: key.
		(value isKindOf: self class)
			ifTrue: [ value allPathsStartingWith: currentPath into: aCollection ]
			ifFalse: [ aCollection add: currentPath ] ]
]

{ #category : 'enumerating' }
CTKeyedTree >> anySatisfy: aBlock [

	self valuesDo: [ :value |
		(aBlock value: value) ifTrue: [ ^ true ].
		(value isKindOf: self class) ifTrue: [
			(value anySatisfy: aBlock) ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : 'converting' }
CTKeyedTree >> asArray [

	| result |
	result := OrderedCollection new.
	self valuesDo: [ :value |
			(value isKindOf: self class)
				ifTrue: [ result addAll: value ]
				ifFalse: [ result add: value ] ].
	^ result asArray
]

{ #category : 'converting' }
CTKeyedTree >> asDictionary [

	| dict |
	dict := Dictionary new.
	self keysAndValuesDo: [ :key :value |
		dict at: key put: (
			(value isKindOf: self class)
				ifTrue: [ value asDictionary ]
				ifFalse: [ value ]) ].
	^ dict
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray [

	"Answer the element at the given path. Signal KeyNotFound if not found."
	
	^ self atPath: pathArray ifAbsent: [ 
		KeyNotFound signalFor: pathArray in: self ]
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray ifAbsent: absentBlock [

	"Answer the element at the given path, or the result of absentBlock if not found."
	
	| currentElement |
	currentElement := self.
	pathArray do: [ :key | 
		(currentElement isKindOf: self class)
			ifTrue: [ 
				currentElement := currentElement 
					at: key 
					ifAbsent: [ ^ absentBlock value ] ]
			ifFalse: [ ^ absentBlock value ] ].
	^ currentElement
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray ifAbsent: absentBlock ifPresent: presentBlock [

	"Two-way conditional access to path elements"
	
	| element |
	element := self atPath: pathArray ifAbsent: [ ^ absentBlock value ].
	^ presentBlock cull: element
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray ifAbsentPut: absentBlock [

	"Answer the element at the given path. If not found, create the path and set the value from absentBlock."
	
	| currentElement |
	pathArray isEmpty ifTrue: [ ^ self ].
	
	currentElement := self.
	pathArray allButLastDo: [ :key | 
		currentElement := currentElement 
			at: key 
			ifAbsentPut: [ self species new ] ].
	
	^ currentElement at: pathArray last ifAbsentPut: absentBlock
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray ifPresent: presentBlock [

	"Evaluate presentBlock with the element at pathArray if it exists. Otherwise answer nil."
	
	^ self 
		atPath: pathArray 
		ifAbsent: [ nil ]
		ifPresent: presentBlock
]

{ #category : 'accessing' }
CTKeyedTree >> atPath: pathArray put: value [
	"Set the element at the given path to value. Create intermediate paths as needed."

	| currentElement |
	pathArray isEmpty ifTrue: [ ^ value ].
	
	currentElement := self.
	pathArray allButLastDo: [ :key | 
		currentElement := currentElement 
			at: key 
			ifAbsentPut: [ self species new ].
		
		"Add this check to provide a better error message"
		(currentElement isKindOf: self class) ifFalse: [
			^ KeyNotFound signalFor: key in: self ] ].
			
	^ currentElement at: pathArray last put: value
]

{ #category : 'enumerating' }
CTKeyedTree >> collect: aBlock [

	"Answer a new collection with transformed values. Maintains tree structure."
	
	| result |
	result := self species new.
	self keysAndValuesDo: [ :key :value |
		result at: key put: (
			(value isKindOf: self class)
				ifTrue: [ value collect: aBlock ]
				ifFalse: [ aBlock value: value ] ) ].
	^ result
]

{ #category : 'copying' }
CTKeyedTree >> copy [

		"Answer a deep copy of the receiver including all subtrees."
	
	| result |
	result := self species new.
	self keysAndValuesDo: [ :key :value |
		result at: key put: (
			(value isKindOf: self class)
				ifTrue: [ value copy ]
				ifFalse: [ value ] ) ].
	^ result
]

{ #category : 'accessing' }
CTKeyedTree >> depth [

		"Answer the maximum depth of this tree (number of levels)"
	
	| maxSubtreeDepth |
	self isEmpty ifTrue: [ ^ 0 ].
	
	maxSubtreeDepth := self subtrees
		inject: 0
		into: [ :max :subtree | max max: subtree depth ].
	
	^ 1 + maxSubtreeDepth
]

{ #category : 'enumerating' }
CTKeyedTree >> detect: aBlock ifNone: noneBlock [

	"Answer the first element that satisfies the condition, including in subtrees."
	
	self valuesDo: [ :value |
		(value isKindOf: self class)
			ifTrue: [ 
				| found |
				found := value detect: aBlock ifNone: [ nil ].
				found ifNotNil: [ ^ found ] ]
			ifFalse: [ 
				(aBlock value: value) ifTrue: [ ^ value ] ] ].
	^ noneBlock value
]

{ #category : 'enumerating' }
CTKeyedTree >> do: aBlock [

	self valuesDo: [ :value |
		(value isKindOf: self class)
			ifTrue: [ value do: aBlock ]
			ifFalse: [ aBlock value: value ] ]
]

{ #category : 'accessing' }
CTKeyedTree >> existsPath: pathArray [

	"Answer true if a path exists in the tree."
	
	^ (self atPath: pathArray ifAbsent: [ nil ]) notNil
]

{ #category : 'printing' }
CTKeyedTree >> formattedText [

	"Answer a formatted string representation with proper indentation."
	
	^ String streamContents: [ :stream | 
		self putFormattedTextOn: stream level: 0 indentString: '  ' ]
]

{ #category : 'testing' }
CTKeyedTree >> hasPath: pathArray [

	"Answer true if the given path exists in this tree."
	
	^ self existsPath: pathArray
]

{ #category : 'testing' }
CTKeyedTree >> hasSubtrees [

	"Answer true if the receiver contains any subtrees."
	
	^ self anySatisfy: [ :value | value isKindOf: self class ]
]

{ #category : 'testing' }
CTKeyedTree >> includesPath: pathArray [

	"Answer true if the path exists in the tree."
	
	^ self hasPath: pathArray
]

{ #category : 'testing' }
CTKeyedTree >> isDeep [

	"Answer true if this tree has subtrees (depth > 1)."
	
	^ self hasSubtrees
]

{ #category : 'testing' }
CTKeyedTree >> isFlat [

	"Answer true if this tree contains no subtrees (depth = 1)."
	
	^ self hasSubtrees not
]

{ #category : 'testing' }
CTKeyedTree >> isLeaf [

	"Answer true if this tree contains no subtrees (only direct values)."
	
	^ self subtrees isEmpty
]

{ #category : 'enumerating' }
CTKeyedTree >> keysAndPathsDo: aBlock [

	"Evaluate aBlock with each key and its full path from root"
	
	self keysAndPathsStartingWith: #() do: aBlock
]

{ #category : 'private' }
CTKeyedTree >> keysAndPathsStartingWith: pathPrefix do: aBlock [

	"Private method for recursive path enumeration"
	
	self keysAndValuesDo: [ :key :value |
		| fullPath |
		fullPath := pathPrefix copyWith: key.
		aBlock value: key value: fullPath.
		(value isKindOf: self class)
			ifTrue: [ value keysAndPathsStartingWith: fullPath do: aBlock ] ]
]

{ #category : 'accessing' }
CTKeyedTree >> leafValues [

	"Answer a collection of all non-tree values in this tree"
	
	| leaves |
	leaves := OrderedCollection new.
	self keysAndValuesDo: [ :key :value |
		(value isKindOf: self class)
			ifTrue: [ leaves addAll: value leafValues ]
			ifFalse: [ leaves add: value ] ].
	^ leaves
]

{ #category : 'actions' }
CTKeyedTree >> merge: aKeyedTree [

	"Merge the given tree into the receiver. Subtrees are merged recursively, other values are overwritten."
	
	aKeyedTree keysAndValuesDo: [ :key :value | 
		| existingValue |
		existingValue := self at: key ifAbsent: [ nil ].
		
		(value isKindOf: self class)
			ifTrue: [ 
				(existingValue isKindOf: self class)
					ifTrue: [ existingValue merge: value ]
					ifFalse: [ self at: key put: value copy ] ]
			ifFalse: [ self at: key put: value ] ].
	^ self
]

{ #category : 'accessing' }
CTKeyedTree >> nodeCount [

	"Answer the total number of key-value pairs in this tree and all its subtrees."
	
	^ self size + (self subtrees 
		inject: 0 
		into: [ :sum :subtree | sum + subtree nodeCount ])
]

{ #category : 'selecting' }
CTKeyedTree >> pathOf: anObject [

	"Answer the path to the first occurrence of anObject in this tree, or nil if not found"
	
	^ self pathOf: anObject startingWith: #()
]

{ #category : 'private' }
CTKeyedTree >> pathOf: anObject startingWith: pathPrefix [

	self keysAndValuesDo: [ :key :value |
		| currentPath |
		currentPath := pathPrefix copyWith: key.
		value = anObject ifTrue: [ ^ currentPath ].
		(value isKindOf: self class) ifTrue: [
			| foundPath |
			foundPath := value pathOf: anObject startingWith: currentPath.
			foundPath ifNotNil: [ ^ foundPath ] ] ].
	^ nil
]

{ #category : 'enumerating' }
CTKeyedTree >> pathsAndValuesDo: aBlock [

	"Execute aBlock with each path-value pair in the tree."
	
	self pathsAndValuesDo: aBlock currentPath: #()
]

{ #category : 'enumerating' }
CTKeyedTree >> pathsAndValuesDo: aBlock currentPath: pathArray [

	self keysAndValuesDo: [ :key :value |
		| newPath |
		newPath := pathArray copyWith: key.
		(value isKindOf: self class)
			ifTrue: [ 
				aBlock value: newPath value: value.
				value pathsAndValuesDo: aBlock currentPath: newPath ]
			ifFalse: [ aBlock value: newPath value: value ] ]
]

{ #category : 'copying' }
CTKeyedTree >> postCopy [

	"Ensure proper deep copying of associations and subtrees."
	
	array := array collect: [ :assoc |
		assoc ifNotNil: [ 
			Association
				key: assoc key
				value: ((assoc value isKindOf: self class)
					ifTrue: [ assoc value copy ]
					ifFalse: [ assoc value ]) ] ]
]

{ #category : 'printing' }
CTKeyedTree >> printOn: aStream [

	"Print a concise representation showing the tree structure."
	
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	self isEmpty 
		ifTrue: [ aStream nextPutAll: 'empty' ]
		ifFalse: [ 
			aStream print: self size.
			aStream nextPutAll: ' keys'.
			self hasSubtrees ifTrue: [ 
				aStream nextPutAll: ', '.
				aStream print: self subtrees size.
				aStream nextPutAll: ' subtrees' ] ].
	aStream nextPut: $)
]

{ #category : 'printing' }
CTKeyedTree >> putFormattedTextOn: aStream level: indentLevel indentString: indentString [

	"Write formatted representation to stream with proper indentation."
	
	| sortedKeys |
	sortedKeys := self keys asSortedCollection: self sortBlock.
	
	sortedKeys do: [ :key | 
		| value |
		value := self at: key.
		
		"Add indentation"
		indentLevel > 0 ifTrue: [ 
			indentLevel - 1 timesRepeat: [ aStream nextPutAll: indentString ].
			aStream nextPutAll: '  ' ].
		
		"Add key"
		aStream nextPutAll: key printString.
		
		"Add value or recurse into subtree"
		(value isKindOf: self class)
			ifTrue: [ 
				aStream cr.
				value putFormattedTextOn: aStream 
					level: indentLevel + 1 
					indentString: indentString ]
			ifFalse: [ 
				aStream nextPutAll: ' : '.
				aStream nextPutAll: value printString.
				aStream cr ] ]
]

{ #category : 'removing' }
CTKeyedTree >> removePath: pathArray [

	"Remove and answer the element at the given path. Signal error if not found."
	
	^ self removePath: pathArray ifAbsent: [ 
		KeyNotFound signalFor: pathArray in: self ]
]

{ #category : 'removing' }
CTKeyedTree >> removePath: pathArray ifAbsent: absentBlock [

	"Remove and answer the element at the given path, or execute absentBlock if not found."
	
	| currentElement |
	pathArray isEmpty ifTrue: [ ^ absentBlock value ].
	
	currentElement := self.
	pathArray allButLastDo: [ :key | 
		currentElement := currentElement 
			at: key 
			ifAbsent: [ ^ absentBlock value ] ].
			
	^ currentElement removeKey: pathArray last ifAbsent: absentBlock
]

{ #category : 'enumerating' }
CTKeyedTree >> select: aBlock [

	"Answer a new tree containing only elements that satisfy the condition."
	
	| result |
	result := self species new.
	self keysAndValuesDo: [ :key :value |
		(value isKindOf: self class)
			ifTrue: [ 
				| selectedSubtree |
				selectedSubtree := value select: aBlock.
				selectedSubtree isEmpty ifFalse: [ 
					result at: key put: selectedSubtree ] ]
			ifFalse: [ 
				(aBlock value: value) ifTrue: [ 
					result at: key put: value ] ] ].
	^ result
]

{ #category : 'sorting' }
CTKeyedTree >> sortBlock [

	"Answer a sort block for ordering keys. Symbols come before numbers, then by class name."
	
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

{ #category : 'accessing' }
CTKeyedTree >> subtrees [
	"Answer a collection of all immediate subtrees."

	^ self values select: [ :each | each isKindOf: self class ]
]

{ #category : 'accessing' }
CTKeyedTree >> treeDepth [

	^ self depth 
]

{ #category : 'accessing' }
CTKeyedTree >> treeSize [
	"Answer the total number of leaf elements in the tree including all subtrees."

	| count |
	count := 0.
	self valuesDo: [ :value |
			count := (value isKindOf: self class)
				         ifTrue: [ count + value treeSize ]
				         ifFalse: [ count + 1 ] ].
	^ count
]

{ #category : 'enumerating' }
CTKeyedTree >> valuesAndPathsDo: aBlock [

"Evaluate aBlock with each leaf value and its full path from root"
	
	self valuesAndPathsStartingWith: #() do: aBlock
]

{ #category : 'private' }
CTKeyedTree >> valuesAndPathsStartingWith: pathPrefix do: aBlock [

	self keysAndValuesDo: [ :key :value |
		| fullPath |
		fullPath := pathPrefix copyWith: key.
		(value isKindOf: self class)
			ifTrue: [ value valuesAndPathsStartingWith: fullPath do: aBlock ]
			ifFalse: [ aBlock value: value value: fullPath ] ]
]
