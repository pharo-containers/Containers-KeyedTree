Class {
	#name : 'BaselineOfContainersKeyedTree',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfContainersKeyedTree',
	#package : 'BaselineOfContainersKeyedTree'
}

{ #category : 'baselines' }
BaselineOfContainersKeyedTree >> baseline: spec [

	<baseline>
    spec for: #common do: [
            spec package: 'Containers-KeyedTree'.
            spec
                package: 'Containers-KeyedTree-Tests'
                with: [ spec requires: #( 'Containers-KeyedTree' ) ] ]
]
