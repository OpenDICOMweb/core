# Element Design

## Element Design
Each Element has two components:

    Tag: A constant object that defines the Semantic Code,
         Data Type (VR), Attribute Type, Value Multiplicity (VM).
         
    Values: A _Fixed length_ list of values that conform to the requirements
         of the Tag. However, the constructors and Setters for _values_ take 
         an _Iterable_ of Type _T_ and coerce it to a list before it is stored.

## Element Tag Design

### Semantic Identifier

A Semantic Identifier is composed of an integer _code_, a string _keyword_, and 
a string _name_.

### Data Type or Value Representation

    - base type: integer, Float, String
    - max value field size (16 or 32 bits)
    - parser

### Data Shape of Value Multiplicity

## Element Mixin