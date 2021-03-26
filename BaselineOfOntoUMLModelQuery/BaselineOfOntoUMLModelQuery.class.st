Class {
	#name : #BaselineOfOntoUMLModelQuery,
	#superclass : #BaselineOf,
	#category : #BaselineOfOntoUMLModelQuery
}

{ #category : #baselines }
BaselineOfOntoUMLModelQuery >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'OntoUMLProfile'
				with: [ spec
						repository: 'github://openponk/ontouml-profile/repository';
						loads: self halt ].
			spec package: 'OntoUML-ModelQuery'.
			spec group: 'plugin' with: #('OntoUML-ModelQuery').
			spec group: 'default' with: #(OntoUMLProfile plugin) ]
]
