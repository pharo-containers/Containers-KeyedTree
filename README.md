# Containers-KeyedTree
An implementation of KeyedTree

## Install
To install this project, run the following script in a playground:

```st
Metacello new
	baseline: 'ContainersKeyedTree';
	repository: 'github://Ducasse/Containers-KeyedTree/src';
	load.
```

## Example
To have an overview of the features this datastructure provide, have a look at the following code snippet (extracted from a unit test):

```st
firstLevelOneSubTree := KeyedTree new.
firstLevelOneSubTree
	at: #two put: 'One-Two';
	at: #three put: 'One-Three'.
	
tree := KeyedTree new.
tree
	at: 1 put: firstLevelOneSubTree;
	at: 2 put: 'Two'.
	
self assert: (tree atPath: #(1)) equals: firstLevelOneSubTree.
self assert: (tree atPath: #(1 two)) equals: 'One-Two'.
self assert: (tree atPath: #(1 three)) equals: 'One-Three'.
self assert: (tree atPath: #(2)) equals: 'Two'.
self should: [ tree atPath: #(2 4) ] raise: self defaultTestError.
self should: [ tree atPath: #(1 two three) ] raise: self defaultTestError.
self should: [ tree atPath: #(3) ] raise: self defaultTestError
```
