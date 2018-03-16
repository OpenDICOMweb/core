H0 Element Design

H0 Element Classes

H1 Element (abstract)

H1 Byte Class
A Type of Element that is constructed from an array of bytes. In this
class each Element is constructed from a contiguous array of bytes ([Bytes])*

H2 Design goals
  * parse a byte stream and create a dataset and elements that refer
    to it.
  * Use as little storage as possible.
  * Elements may or may not be validated as they are parsed. Typically
    they are not validated, when parsing - this is done later.

H2 Advantages


H1 Tag Class
A Type of Element that is constructed from an array of bytes.

