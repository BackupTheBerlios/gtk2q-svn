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
	"TGtkSourceBuffer": ["IGObject", "IGtkTextBuffer"],
	#"TGtkSourceMarker": ["IGtkTextMark"], # typedef GtkTextMark      GtkSourceMarker;
	"TGtkSourceView": ["IGObject",  "IGtkObject", "IGInitiallyUnowned", "IGtkObject", "IGtkWidget", "IGtkContainer", "IGtkTextView"],
	"TGtkSourceLanguage": ["IGObject"],
	"TGtkSourceLanguagesManager": ["IGObject"],
	#"TGtkSourceStyleScheme": ["GInterface"],
	"TGtkSourceTag": ["IGObject", "IGtkTextTag"],
	"TGtkSyntaxTag": ["IGObject", "IGtkTextTag", "TGtkSourceTag"],
	"TGtkPatternTag": ["IGObject", "IGtkTextTag", "TGtkSourceTag"],
	"TGtkSourceTagTable": ["IGObject", "IGtkTextTagTable"],
	"TGtkSourcePrintJob": ["IGObject"],
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
	#"TGtkSourceBuffer": ["TGdkEvent"],
}

# signal units uses clause, used classes for implementation section
psignalusediocimpl = {
	#"TGtkSourceBuffer": ["TGnomeCanvasBuf"], 
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
	"TGtkSourceTagStyle",
]

# maps from interface name to interface unit name for special cases
interfaceunitoverride = {
	#"IGnomeCanvasBuf": "iugnomecanvasbuf",
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
	"GtkSourceBuffer",
	"GtkSourceMarker",
	"GtkSourceView",
	"GtkSourceLanguage",
	"GtkSourceLanguagesManager",
	"GtkSourceStyleScheme",
	"GtkSourceTag",
	"GtkSourceTagTable",
	#"GtkSourceTagStyle",
	"GtkSourcePrintJob",
]

# list of parameters that are used as 'const ...*' uselessly (from a pascal point of view)
c2pconstpointerparam = [ # 'const GdkColor*' as parameter
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
        ## GtkSource cclassconstructparams
	"GtkSourceBuffer": "nil", # TODO support passing the source tag table
	# GtkSourceMarker has a few new methods... weird.
	"GtkSourceView": "", # TODO with buffer, too?
	"GtkSourceLanguage": None, # not constructable
	"GtkSourceLanguagesManager": "",
	"GtkSourceStyleScheme": None, # not constructable.
	"GtkSourceTag": None, # manual constructor
	"GtkSyntaxTag": None, # manual constructor
	"GtkPatternTag": None, # manual constructor
	"GtkSourceTagTable": "",
	"GtkSourceTagStyle": None, # pointermediator
	"GtkSourcePrintJob": None, # need gnome print config
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
	## GtkSource forceexternals
	"gtk_syntax_tag_new", # manually
	"gtk_pattern_tag_new", # manually
	"gtk_keyword_list_tag_new", # manually
	"gtk_block_comment_tag_new", # manually
	"gtk_line_comment_tag_new", # manually
	"gtk_string_tag_new", # manually
]

paddmembervars = {
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
	## GtkSource
	"GtkSyntaxTag": {
		"Create": """
			public constructor Create(id, name, patternStart, patternEnd: UTF8String);
			begin
			  setWrapped(gtk_syntax_tag_new(id, name, patternStart, patternEnd));
                        end;
		"""
	},
	"GtkSourceTag": {
		"CreatePatternTag": """
			public constructor CreatePatternTag(id, name, pattern: UTF8String);
			begin
			  setWrapped(gtk_pattern_tag_new(id, name, pattern));
			end;
		""",
		"CreateKeywordListTag": """
			public constructor CreateKeywordListTag(id, name: UTF8String; const keywords: TUTF8StringArray; caseSensitive, matchEmptyStringAtBeginning, matchEmptyStringAtEnd: Boolean; beginningRegex, endRegex: UTF8String);
			begin
			  setWrapped(gtk_keyword_list_tag_new(id, name, keywords, caseSensitive, matchEmptyStringAtBeginning, matchEmptyStringAtEnd, beginningRegex, endRegex));
			end;
		""",
		"CreateBlockCommentTag": """
			public constructor CreateBlockCommentTag(id, name, patternStart, patternEnd: UTF8String);
			begin
			  setWrapped(gtk_syntax_tag_new(id, name, patternStart, patternEnd));
			end;
		""",
		"CreateLineCommentTag": """
			public constructor CreateLineCommentTag(id, name, patternStart: UTF8String);
			begin
			  setWrapped(gtk_line_comment_tag_new(id, name, patternStart));
			end;
		""",
		"CreateStringTag": """
			public constructor CreateStringTag(id, name, patternStart, patternEnd: UTF8String; endAtLineEnd: Boolean);
			begin
			  setWrapped(gtk_string_tag_new(id, name, patternStart, patternEnd, endAtLineEnd));
			end;
		"""
	},
	
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
}

# functions to be skipped and not be wrapped
cskipfuncs = [
	## GtkSource cskipfuncs
	"gtk_syntax_tag_new", # manually
	"gtk_pattern_tag_new", # manually
	"gtk_keyword_list_tag_new", # manually
	"gtk_block_comment_tag_new", # manually
	"gtk_line_comment_tag_new", # manually
	"gtk_string_tag_new", # manually
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
	## GtkSource c2pfuncparamoverride
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
	## GtkSource paddexternalgettype
	
]

# typemap for external declarations (C) -> pascal, prefix "const " for const-params
externaltypemap = {
}

# ptypename: {"SIMPLE"|"PARAMSPEC"|"ENUM"|"MEDIATOROBJECT"|"OBJECT"|"RECORD"}
csignalhandlerargtype2definemap = {
	"IGtkSourceTagStyle": "MEDIATOROBJECT",
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

ptyperegisterinit = {
}
