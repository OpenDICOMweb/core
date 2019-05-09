# Bytes

The Bytes package unifies the Dart [Uint8] and [ByteData] classes. 
It has the following advantages:

    - A Bytes is always either Little Endian (default) or Big Endian.
    - A Little Endian Bytes can be converted into a Big Endian bytes 
      using the [.from] constructor.
    - The Bytes package provides Getters and Setters for both single 
      elements and arrays (fixed length lists).
    - The Bytes package provides the following mixins:
        - 
