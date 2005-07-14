#!/usr/bin/env python

# pstringtype = "UTF8String"
# classprefix = "T"
# enumprefix = "T"
# interfaceprefix = "I"
# interfaceunitprefix = "iu"
# classunitprefix = "u"
# wrapperpointerprefix = "PW"
# wrapperprefix = "W"

# type to use for storing the return value of Object Property Accessors
ptype1 = {
}

# hash of class -> uses clause additions (interface or implementation class name):
#    (interface names are added at the unit interface section)
#    (implementation class names are added at the unit implementation section)
pusedclasses = { # from class implementation: list of classes used (implementation 'uses' clause for classes, interface 'uses' clause for interfaces)
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
}

# signal units uses clause, used classes for implementation section
psignalusediocimpl = {
}

# these are array types that are to be automagically casted to the right type 
# when calling the wrapped function in the wrapper (to prevent array mismatch)
# add only when you get an array type mismatch.
# add C type name as given in the array override as [1]
poverridearraytypes = {
}

# hash of transformers for preturn, given that they arent obvious.
# examples for required manual transformers are:
#   - pointer to (structure or exception) transformer
preturntransformers = {
}

# list of classes that are not gobject (usually pointermediators) but are wrappers
nongobjectclasses = [
]

# maps from interface name to interface unit name for special cases
interfaceunitoverride = {
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
]

# list of parameters that are used as 'const ...*' uselessly (from a pascal point of view)
c2pconstpointerparam = [ # 'const GdkColor*' as parameter
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
}

# direct type mapping
# contains type mappings for primitive types, for use in the interfaces
# be careful with that.
c2ptypehash = {
}

c2penumcopied = [ # enums copied to delphi as-is
]

# structs copied from gtk to the wrapped (into unit u...types) 
c2pstructcopied = { # simple structs copied to delphi as-is
}

# class (not instance) functions to get from C
c2pclassfunctions = { 
}

cskipsignals = [
]

# properties that are to be skipped and not be wrapped (f.e. deprecated properties)
cskipprops = [
]

# externals to force
forceexternals = [
]

paddmembervars = {
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
}

# functions to be skipped and not be wrapped
cskipfuncs = [
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
}


c2psignalparamoverride = {
}

c2pproptypeoverride = {
}

c2pfuncparamnullable = {
}

#signalintf = ""
#signalimpl = ""

# where to add xxx_get_type external function explicitly (since its missing in the source xml)
paddexternalgettype = [
]

# typemap for external declarations (C) -> pascal, prefix "const " for const-params
externaltypemap = {
}

# ptypename: {"SIMPLE"|"PARAMSPEC"|"ENUM"|"MEDIATOROBJECT"|"OBJECT"|"RECORD"}
csignalhandlerargtype2definemap = {
}

# for determining whether to include c*.inc or not:
# this should become less with time
underivable = [
]

# TODO use that
classoverridables = {
}

# widgets that will be created without passing a C widget instance (ie NEW instances)
# will use this code after construction:
pextraconstructcode = {
}

superclassoverride = {
}

csettypes = [
]
