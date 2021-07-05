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
				baseline: 'OntoUMLProfile-Plugin'
				with: [ spec
						className: 'BaselineOfOntoUMLProfile';
						repository: 'github://hernanmd/ontouml-profile';
						loads: 'plugin' ].
			spec
				project: 'OntoUMLProfile'
				copyFrom: 'OntoUMLProfile-Plugin'
				with: [ spec loads: 'default' ].
			spec package: 'OntoUML-ModelQuery'.
			spec
				group: 'plugin'
				with: #('OntoUMLProfile-Plugin' 'OntoUML-ModelQuery').
			spec group: 'default' with: #(OntoUMLProfile 'OntoUML-ModelQuery') ]
]
