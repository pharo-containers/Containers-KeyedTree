# Containers-KeyedTree
An implementation of KeyedTree

[![Build Status](https://travis-ci.com/Ducasse/Containers-KeyedTree.svg?branch=master)](https://travis-ci.com/Ducasse/Containers-KeyedTree)
[![Coverage Status](https://coveralls.io/repos/github//Ducasse/Containers-KeyedTree/badge.svg?branch=master)](https://coveralls.io/github//Ducasse/Containers-KeyedTree?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Pharo version](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
<!-- [![Build status](https://ci.appveyor.com/api/projects/status/1wdnjvmlxfbml8qo?svg=true)](https://ci.appveyor.com/project/olekscode/dataframe)  -->



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

## Loading

The following script installs Containers-Stack in Pharo.

```st
Metacello new
	baseline: 'ContainersKeyedTree';
	repository: 'github://Ducasse/Containers-KeyedTree/src';
	load.
```

## If you want to depend on it

Add the following code to your Metacello baseline or configuration

```
spec 
   baseline: 'ContainersKeyedTree' 
   with: [ spec repository: 'github://Ducasse/Containers-KeyedTree/src' ]
```
