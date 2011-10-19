// Delegate.cpp
// This file is part of the EScript programming language.
// See copyright notice in EScript.h
// ------------------------------------------------------
#include "Delegate.h"

#include "../EScript.h"

using namespace EScript;
//---

Type* Delegate::typeObject=NULL;

//! initMembers
void Delegate::init(EScript::Namespace & globals) {
	// Delegate ---|> [Object]
	typeObject=new Type(Object::getTypeObject());
	declareConstant(&globals,getClassName(),typeObject);

	//!	[ESMF] Delegate new Delegate(object,function)
	ESF_DECLARE(typeObject,"_constructor",2,2,	new Delegate(parameter[0],parameter[1]))

	//!	[ESMF] Object Delegate.getObject()
	ESMF_DECLARE(typeObject,Delegate,"getObject",0,0,self->getObject())

	//!	[ESMF] Object Delegate.getFunction()
	ESMF_DECLARE(typeObject,Delegate,"getFunction",0,0,self->getFunction())
}

//---

//! (ctor)
Delegate::Delegate(ObjPtr object,ObjPtr function):
		Object(typeObject),myObjectRef(object.get()),functionRef(function.get()) {
	//ctor
}

//! (dtor)
Delegate::~Delegate() {
	//dtor
}

//! ---|> [Object]
Delegate * Delegate::clone() const{
	return new Delegate(getObject(),getFunction());
}

//! ---|> [Object]
bool Delegate::rt_isEqual(Runtime &,const ObjPtr o){
	Delegate * d=o.toType<Delegate>();
	return (d!=NULL) &&   d->getObject()==getObject() && d->getFunction()==getFunction();
}

//! ---|> [Object]
std::string Delegate::toDbgString()const {
	return std::string("("+myObjectRef.toString("?")+"->"+(functionRef.isNull() ? "?" : functionRef->toDbgString())+")");
}
