Class {
	#name : #OntoUMLModelQueryTest,
	#superclass : #TestCase,
	#category : #'OntoUML-ModelQuery'
}

{ #category : #'tests - utility' }
OntoUMLModelQueryTest >> createAssociationFrom: aSource to: aEnd [
	| association|
	association := OPUMLAssociation new.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aSource.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aEnd.
	association memberEnds addAll: association ownedEnds.
	^ association
]

{ #category : #'tests - utility' }
OntoUMLModelQueryTest >> createClass: aName withStereotype: aStereotype [
	| result |
	result := OPUMLClass new.
	result applyStereotype: aStereotype new.
	result name: aName.
	^ result.
]

{ #category : #'tests - utility' }
OntoUMLModelQueryTest >> createGeneralizationFor: aGeneral withSpecific: aSpecific [
	| generalization |
	generalization := OPUMLGeneralization new.
	generalization general: aGeneral;
	specific: aSpecific.
	^ generalization.
]

{ #category : #'tests - utility' }
OntoUMLModelQueryTest >> getClassBlockSorter [
	^ [ :a :b | a name <= b name].
]

{ #category : #'tests - constants' }
OntoUMLModelQueryTest >> getTestAssociation [
	| kind quality association |
	kind := self createClass: 'kind' withStereotype: OntoUMLKind.
	quality := self createClass: 'quality' withStereotype: OntoUMLQuality.
	association := self createAssociationFrom: kind to: quality.
	association applyStereotype: OntoUMLCharacterization new.
	association memberEnds first lowerValue value: 2.
	association memberEnds first upperValue value: '*'.
	^ association.
]

{ #category : #'tests - constants' }
OntoUMLModelQueryTest >> getTestModelForAssociations [
	| kind subkind quality role mediationToKind mediationToSubKind characterization generalization |
	kind := self createClass: 'kind' withStereotype: OntoUMLKind.
	subkind := self createClass: 'subkind' withStereotype: OntoUMLSubKind.
	role := self createClass: 'role' withStereotype: OntoUMLRole.
	quality := self createClass: 'quality' withStereotype: OntoUMLQuality.
	characterization := self createAssociationFrom: kind to: quality.
	characterization applyStereotype: OntoUMLCharacterization new.
	mediationToKind := self createAssociationFrom: kind to: role.
	mediationToKind applyStereotype: OntoUMLCharacterization new.
	mediationToSubKind := self createAssociationFrom: subkind to: role.
	mediationToSubKind applyStereotype: OntoUMLCharacterization new.
	generalization := self createGeneralizationFor: kind withSpecific: subkind.
	^ { kind. subkind. quality. role. mediationToKind. mediationToSubKind. characterization. generalization. }.
]

{ #category : #'tests - constants' }
OntoUMLModelQueryTest >> getTestModelForEntities [
	| elementKind elementSubKindA elementSubKindB elementQuality association generalizationA generalizationB |
	elementKind := self createClass: 'elementKind' withStereotype: OntoUMLKind.
	elementSubKindA := self createClass: 'elementSubKindA' withStereotype: OntoUMLSubKind.
	elementSubKindB := self createClass: 'elementSubKindB' withStereotype: OntoUMLSubKind.
	elementQuality := self createClass: 'elementQuality' withStereotype: OntoUMLQuality.
	association := self createAssociationFrom: elementKind to: elementQuality.
	association applyStereotype: OntoUMLCharacterization new.
	generalizationA := self createGeneralizationFor: elementKind withSpecific: elementSubKindA.
	generalizationB := self createGeneralizationFor: elementKind withSpecific: elementSubKindB.
	^ { elementKind. elementSubKindA. elementSubKindB. elementQuality. association. generalizationA. generalizationB }.
]

{ #category : #'tests - constants' }
OntoUMLModelQueryTest >> getTestModelForGeneralizations [
	| testedChild parent1 parent2 parent3 testedParent sibling outsideElement |
	testedChild := 	self createClass: 'testedChild' withStereotype: OntoUMLRole.
	parent1 := self createClass: 'parent1' withStereotype: OntoUMLRoleMixin.
	parent2 := self createClass: 'parent2' withStereotype: OntoUMLSubKind.
	parent3 := self createClass: 'parent3' withStereotype: OntoUMLSubKind.
	testedParent := self createClass: 'testedParent' withStereotype: OntoUMLKind.
	sibling := 	self createClass: 'sibling' withStereotype: OntoUMLRole.
	outsideElement := self createClass: 'outsideElement' withStereotype: OntoUMLKind.
	
	^ { testedChild. testedParent. parent1. parent2. parent3.  sibling. outsideElement. 
		self createGeneralizationFor: parent1 withSpecific: testedChild.
		self createGeneralizationFor: parent2 withSpecific: testedChild.
		self createGeneralizationFor: parent3 withSpecific: parent2.
		self createGeneralizationFor: parent2 withSpecific: parent3.
		self createGeneralizationFor: testedParent withSpecific: parent2.
		self createGeneralizationFor: parent1 withSpecific: sibling.
		}.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAncestorsFor [
	| model result |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent1'. 'parent2'. 'parent3'. 'testedParent'. } includes: entity name ])
		sorted: self getClassBlockSorter.
	self assert: ((OntoUMLModelQuery getAncestorsFor: model first) sorted: self getClassBlockSorter) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAncestorsForInto [
	| model outputAccumulator result |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent1'. 'parent2'. 'parent3'. 'testedParent'. } includes: entity name ])
		sorted: self getClassBlockSorter.
	outputAccumulator := Set new.
	OntoUMLModelQuery getAncestorsFor: model first into: outputAccumulator. 
	self assert: (outputAccumulator sorted: self getClassBlockSorter) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAssociationsFrom [
	| model result |
	model := self getTestModelForAssociations.
	result := model select: [ :object | object isKindOf: OPUMLAssociation. ].
	self assert: (OntoUMLModelQuery getAssociationsFrom: model) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAssociationsFromFilterBy [
	| model result |
	model := self getTestModelForAssociations.
	result := (model select: [ :object | object isKindOf: OPUMLAssociation. ]) select: [ :association | association oclIsKindOf: 'Mediation' ].
	self assert: (OntoUMLModelQuery getAssociationsFrom: model filterBy: [ :association | association oclIsKindOf: 'Mediation' ]) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAssociationsFromWithStereotype [
	| model result |
	model := self getTestModelForAssociations.
	result := (model select: [ :object | object isKindOf: OPUMLAssociation. ]) select: [ :association | association oclIsKindOf: 'Mediation' ].
	self assert: (OntoUMLModelQuery getAssociationsFrom: model withStereotype: OntoUMLMediation) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetAssociationsFromWithStereotypeFilterBy [
	| model result |
	model := self getTestModelForAssociations.
	result := (model select: [ :object | object isKindOf: OPUMLAssociation. ])
		select: [ :association | (association oclIsKindOf: 'Mediation') and: (association memberEnds second type name = 'kind')].
	self assert: (OntoUMLModelQuery getAssociationsFrom: model withStereotype: OntoUMLMediation filterBy: [ :association | association memberEnds second type name = 'kind']) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetChildrenOfFrom [
	| model result  |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent2'. } includes: entity name])
		sorted: self getClassBlockSorter. 
	self assert: ((OntoUMLModelQuery getChildrenOf: model second from: model)
		sorted: self getClassBlockSorter) asOrderedCollection equals: result asOrderedCollection.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetDescendantsForFrom [
	| model result |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent2'. 'parent3'. 'testedChild'. } includes: entity name ])
		sorted: self getClassBlockSorter.
	self assert: ((OntoUMLModelQuery getDescendantsFor: model second from: model) sorted: self getClassBlockSorter) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetDescendantsForFromInto [
	| model result outputAccumulator |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent2'. 'parent3'. 'testedChild'. } includes: entity name ])
		sorted: self getClassBlockSorter.
	outputAccumulator := Set new.
	OntoUMLModelQuery getDescendantsFor: model second from: model into: outputAccumulator.
	self assert: (outputAccumulator sorted: self getClassBlockSorter) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetEntitiesFrom [
	| model result | 
	model := self getTestModelForEntities.
	result := model select: [ :object | object isKindOf: OPUMLClass. ].
	self assert: (OntoUMLModelQuery getEntitiesFrom: model) equals: result. 
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetEntitiesFromFilterBy [
	| model result | 
	model := self getTestModelForEntities.
	result := (model select: [ :object | (object isKindOf: OPUMLClass) ])
			select: [ :element | element name = 'elementKind' ].
	self assert: (OntoUMLModelQuery getEntitiesFrom: model withStereotype: OntoUMLKind) equals: result. 
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetEntitiesFromWithStereotype [
	| model result | 
	model := self getTestModelForEntities.
	result := (model select: [ :object | (object isKindOf: OPUMLClass) ])
			select: [ :element | element name = 'elementKind' ].
	self assert: (OntoUMLModelQuery getEntitiesFrom: model withStereotype: OntoUMLKind) equals: result. 
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetEntitiesFromWithStereotypeFilterBy [
	| model result | 
	model := self getTestModelForEntities.
	result := (model select: [ :object | (object isKindOf: OPUMLClass) ])
			select: [ :element | element name = 'elementSubKindA' ].
	self assert: (OntoUMLModelQuery getEntitiesFrom: model
			withStereotype: OntoUMLSubKind 
			filterBy: [ :entity | entity name = 'elementSubKindA' ]) equals: result. 
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetGeneralizationsFrom [
	| model result  |
	model := self getTestModelForGeneralizations.
	result := model select: [ : object | object isKindOf: OPUMLGeneralization. ].
	self assert: (OntoUMLModelQuery getGeneralizationsFrom: model) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetGeneralizationsFromFilterBy [
	| model result  |
	model := self getTestModelForGeneralizations.
	result := (model select: [ : object | object isKindOf: OPUMLGeneralization. ])
		select: [ :generalization | generalization specific = model first].
	self assert: (OntoUMLModelQuery getGeneralizationsFrom: model filterBy:
		[ :generalization | generalization specific = model first]) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetParentsOf [
	| model result  |
	model := self getTestModelForGeneralizations.
	result := ((model select: [ : object | object isKindOf: OPUMLClass. ])
		select: [ :entity | { 'parent1'. 'parent2' .} includes: entity name])
		sorted: self getClassBlockSorter. 
	self assert: ((OntoUMLModelQuery getParentsOf: model first)
		sorted: self getClassBlockSorter) equals: result asOrderedCollection.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetSourceEndFrom [
	| association result |
	association := self getTestAssociation.
	result := association memberEnds first.
	self assert: (OntoUMLModelQuery getSourceEndFrom: association ) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetSourceFrom [
	| association result |
	association := self getTestAssociation.
	result := association memberEnds first type.
	self assert: (OntoUMLModelQuery getSourceFrom: association ) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetTargetEndFrom [
	| association result |
	association := self getTestAssociation.
	result := association memberEnds second.
	self assert: (OntoUMLModelQuery getTargetEndFrom: association ) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testGetTargetFrom [
	| association result |
	association := self getTestAssociation.
	result := association memberEnds second type.
	self assert: (OntoUMLModelQuery getTargetFrom: association ) equals: result.
]

{ #category : #tests }
OntoUMLModelQueryTest >> testIsOclKindOf [
	| stereotypeKind noStereotype stereotypeMixin |
	stereotypeKind := OntoUMLKind new.
	noStereotype := nil.
	stereotypeMixin := OntoUMLMixin new.
	self assert: (OntoUMLModelQuery is: stereotypeKind oclKindOf: 'Sortal') equals: true.
	self assert: (OntoUMLModelQuery is: stereotypeKind oclKindOf: 'Kind') equals: true.
	self assert: (OntoUMLModelQuery is: noStereotype oclKindOf: 'Sortal') equals: false.
	self assert: (OntoUMLModelQuery is: stereotypeMixin oclKindOf: 'Sortal') equals: false.

]

{ #category : #tests }
OntoUMLModelQueryTest >> testIsStereotypeOfOclKindOf [
	| elementKind elementStereotypeLess elementMixin |
	elementKind := self createClass: 'kind' withStereotype: OntoUMLKind.
	elementStereotypeLess := OPUMLClass new.
	elementMixin := self createClass: 'mixin' withStereotype: OntoUMLMixin.
	self assert: (OntoUMLModelQuery isStereotypeOf: elementKind oclKindOf: 'Sortal') equals: true.
	self assert: (OntoUMLModelQuery isStereotypeOf: elementKind oclKindOf: 'Kind') equals: true.
	self assert: (OntoUMLModelQuery isStereotypeOf: elementStereotypeLess oclKindOf: 'Sortal') equals: false.
	self assert: (OntoUMLModelQuery isStereotypeOf: elementMixin oclKindOf: 'Sortal') equals: false.

]
