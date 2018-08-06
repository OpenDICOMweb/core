# ODW Core Validators and Errors

## Validators

Validators are boolean functions that take at least two arguments:

  1. An object of some Type
  2. An Issues argument, which is typically optional.
  
If the value of the function is _true_ the _Issues_ argument is not affected, but
if the value is false and the Issues argument is not _null_, an error message is added
to it.

## Errors and Error Functions
This directory contains files that define [Error]s and related functions. Error functions typically start with 
_bad..._ or _invalid..._.

  - _bad..._ functions return the[Null] value.
    
  - _invalid..._ functions return _false_.
  
Each function does the following:

  - logs an error message
  - if the [Issues] argument is not _null_ the error message is added to _issues_.
  - if _throwOnError_ is _true_ an Error is thrown
  - finally, either _null_ or _false_ is returned depending on the function prefix, i.e. _bad_ or _invalid_.

