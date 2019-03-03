Class {
	#name : #BaselineOfKeyedTree,
	#superclass : #BaselineOf,
	#category : #BaselineOfContainersKeyedTree
}

{ #category : #baselines }
BaselineOfKeyedTree >> baseline: spec [
	<baseline>

	spec for: #pharo do: [		
		spec package: 'Containers-KeyedTree'.
		spec package: 'Containers-KeyedTree-Tests' with: [ spec requires: #('Containers-KeyedTree') ]
	]
]
