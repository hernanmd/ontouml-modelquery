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
						repository: 'github://openponk/ontouml-profile/repository';
						loads: 'plugin' ].
			spec
				baseline: 'OntoUMLProfile'
				with: [ spec repository: 'github://openponk/ontouml-profile/repository' ].
			spec package: 'OntoUML-ModelQuery'.
			spec
				group: 'plugin'
				with: #('OntoUMLProfile-Plugin' 'OntoUML-ModelQuery').
			spec group: 'default' with: #(OntoUMLProfile 'OntoUML-ModelQuery') ]
]
