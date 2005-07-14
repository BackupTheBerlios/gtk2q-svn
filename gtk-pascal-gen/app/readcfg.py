#!/usr/bin/env python

from defs import *
import sys
import os

def mergeMaps(m1, m2):
  m3 = {}
  
  for k, v in m1.items():
    m3[k] = v
    
  for k, v in m2.items():
    m3[k] = v
    
  return m3
  
def mergeArrays(a1, a2):
  a3 = []
  for item in a1:
    a3.append(item)
    
  for item in a2:
    a3.append(item)
    
  return a3

o = sys.path
try:
  sys.path = [os.environ["gtkpascalgen_indir"]] + sys.path
except:
  pass
  
import localdefs
sys.path = o

_vars = [
  "pstringtype", # str
  "classprefix", # str
  "enumprefix", # str
  "interfaceprefix", # str
  "interfaceunitprefix", # str
  "classunitprefix", # str
  "wrapperpointerprefix", # str
  "wrapperprefix", # str
  #"pvars = { "pstringtype": pstringtype }
  "ptype1", # map
  "pusedclasses", # map # from class implementation: list of classes used (implementation 'uses' clause for classes, interface 'uses' clause for interfaces)
  "psignalusedioc", # map
  "psignalusediocimpl", # map
  "poverridearraytypes", # map
  "preturntransformers", # map
  "nongobjectclasses", # list
  "interfaceunitoverride", # map
  "cclasses", # list # only a subset, mostly for properties of that type
  "c2pconstpointerparam", # list # 'const GdkColor*' as parameter
  "cclassconstructparams", # map
  "c2ptypehash", # map
  "c2penumcopied", # list # enums copied to delphi as-is
  "c2pstructcopied", # map, simple structs copied to delphi as-is
  "c2pclassfunctions", # map
  "cskipsignals", # list
  "cskipprops", # list
  "forceexternals", # list
  "paddmembervars", # map
  "paddfuncs", # map
  "paddprops", # map
  "cskipfuncs", # list
  "c2pcallbackpointers", # map
  "c2pfuncparamoverride", # map
  "c2psignalparamoverride", # map
  "c2pproptypeoverride", # map
  "c2pfuncparamnullable", # map
  "signalintf", # str
  "signalimpl", # str
  "paddexternalgettype", # list
  "externaltypemap", # map
  "csignalhandlerargtype2definemap", # map
  "underivable", # list
  "classoverridables", # map
  "pextraconstructcode", # map
  "superclassoverride", # map
  "csettypes", # list
]

for vname in _vars:
  v1 = eval("%s" % vname)
  if type(v1) == type("") or type(v1) == type(u""):
    try:
      v2 = eval("localdefs.%s" % vname)
    except:
      continue
      
  v2 = eval("localdefs.%s" % vname)
  
  if type(v1) == type({}):
    v3 = mergeMaps(v1,v2)
  elif type(v1) == type("") or type(v1) == type(u""):
    v3 = v2
  else:
    v3 = mergeArrays(v1, v2)
    
  globals()[vname] = v3
