# Tag Elements

Tag Elements are an _encoding independent_ representation of Elements.

## Decoding

When decoded they do not contain any encoding specific information, which means:

- They do not have a Value Field Length field (vfLengthField).

- They do not have padding.

## Encoding

When encoded they are encoded using best practices, which means:

- All values have the correct VR and VM.

- Empty Values have the cannonical representation for empty values in the specified encodeing.

- They do not have Undefined Value Length Field lengths.

- All padding, if any, contains the correct values.
