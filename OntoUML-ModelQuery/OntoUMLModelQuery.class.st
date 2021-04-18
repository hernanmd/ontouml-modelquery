Class {
	#name : #OntoUMLModelQuery,
	#superclass : #Object,
	#traits : 'TProfileGatherer',
	#classTraits : 'TProfileGatherer classTrait',
	#category : #'OntoUML-ModelQuery'
}

{ #category : #generalizations }
OntoUMLModelQuery class >> getAncestorsFor: aChild [
	| ancestorSet |
	ancestorSet := Set new.
	self getAncestorsFor: aChild into: ancestorSet.
	^ ancestorSet.
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getAncestorsFor: aTarget into: aAncestorsSet [ 
	aTarget generalizations do: [ :generalization | 
		(aAncestorsSet includes: generalization general) ifFalse: [ 
			aAncestorsSet add: generalization general.
			self getAncestorsFor: generalization general into: aAncestorsSet. ]. ].
]

{ #category : #associations }
OntoUMLModelQuery class >> getAssociationName: aAssociation [
	^ ((aAssociation memberEnds at: 1) type name) , '->' , ((aAssociation memberEnds at: 2) type name).
]

{ #category : #associations }
OntoUMLModelQuery class >> getAssociationsFrom: aModel [
	^ (aModel select: [ :object | object isKindOf: OPUMLAssociation. ]).
]

{ #category : #associations }
OntoUMLModelQuery class >> getAssociationsFrom: aModel filterBy: aBlockFilter [
	^ (self getAssociationsFrom: aModel) select:
			[ :association | aBlockFilter value: association ].
]

{ #category : #associations }
OntoUMLModelQuery class >> getAssociationsFrom: aModel withStereotype: aStereotypeClass [
	^ (aModel select: [ :object | object isKindOf: OPUMLAssociation. ])
		select: [ :association | (self getStereotypeClass: association) = aStereotypeClass ].
]

{ #category : #associations }
OntoUMLModelQuery class >> getAssociationsFrom: aModel withStereotype: aStereotypeClass filterBy: aBlockFilter [
	^ (self getAssociationsFrom: aModel withStereotype: aStereotypeClass) 
		select: [ :association | aBlockFilter value: association ].
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getChildrenOf: aParent from: aModel [
	^ (self getGeneralizationsFrom: aModel filterBy: 
			[ :generalization | generalization general = aParent ])
				collect: [ :generalization | generalization specific. ].
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getDescendantsFor: aAncestor from: aModel [
	| childrenSet |
	childrenSet := Set new.
	self getDescendantsFor: aAncestor from: aModel into: childrenSet.
	^ childrenSet
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getDescendantsFor: aTarget from: aModel into: aChildrenSet [
	((aModel select: [ :object | object isKindOf: OPUMLGeneralization ])
		select: [ :generalization | generalization general = aTarget ])
		do: [ :generalization | 
			(aChildrenSet includes: generalization specific)
				ifFalse: [ aChildrenSet add: generalization specific.
					self
						getDescendantsFor: generalization specific
						from: aModel
						into: aChildrenSet ] ].
]

{ #category : #entities }
OntoUMLModelQuery class >> getEntitiesFrom: aModel [
	^ aModel select: [ :object | object isKindOf: OPUMLClass. ].
]

{ #category : #entities }
OntoUMLModelQuery class >> getEntitiesFrom: aModel filterBy: aBlockFilter [
	^ (self getEntitiesFrom: aModel) select: [ :element | aBlockFilter value: element. ].
]

{ #category : #entities }
OntoUMLModelQuery class >> getEntitiesFrom: aModel withStereotype: aStereotypeClass [
	^ (aModel select: [ :object | object isKindOf: OPUMLClass. ])
		select: [ :entity | (self getStereotypeClass: entity) = aStereotypeClass ].
]

{ #category : #entities }
OntoUMLModelQuery class >> getEntitiesFrom: aModel withStereotype: aStereotypeClass filterBy: aBlockFilter [
	^ (self getEntitiesFrom: aModel withStereotype: aStereotypeClass) 
		select: [ :entity | aBlockFilter value: entity ].
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getGeneralizationsFrom: aModel [
	^ aModel select: [ :object | object isKindOf: OPUMLGeneralization. ].
]

{ #category : #generalizations }
OntoUMLModelQuery class >> getGeneralizationsFrom: aModel filterBy: aBlockFilter [
	^ (self getGeneralizationsFrom: aModel) select: 
			[ :generalization | aBlockFilter value: generalization ].
	

]

{ #category : #generalizations }
OntoUMLModelQuery class >> getParentsOf: aChild [
	^ aChild generalizations collect: [ :generalization | generalization general. ].
]

{ #category : #associations }
OntoUMLModelQuery class >> getSourceEndFrom: aAssociation [
	^ aAssociation memberEnds first.
]

{ #category : #associations }
OntoUMLModelQuery class >> getSourceFrom: aAssociation [
	^ (self getSourceEndFrom: aAssociation) type.
]

{ #category : #associations }
OntoUMLModelQuery class >> getTargetEndFrom: aAssociation [
	^ aAssociation memberEnds second.
]

{ #category : #associations }
OntoUMLModelQuery class >> getTargetFrom: aAssociation [
	^ (self getTargetEndFrom: aAssociation) type.
]

{ #category : #'accessing - stereotypes' }
OntoUMLModelQuery class >> is: aStereotype oclKindOf: aStereotypeName [
	aStereotype ifNil: [ ^false. ].
	"else"
	^  aStereotype oclIsKindOf: aStereotypeName. 
]

{ #category : #'accessing - stereotypes' }
OntoUMLModelQuery class >> isStereotypeOf: aObject oclKindOf: aStereotypeName [
	| stereotype |
	stereotype := (self getStereotype: aObject).
	stereotype ifNil: [ ^false. ].
	"else"
	^ self is: stereotype oclKindOf: aStereotypeName. 
]
