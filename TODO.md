# TODO Core

1. Convert all ByteData and Uint8List to Bytes.

1. All files that define errors should be re-organized so that errors files related to a specific class are stored with that class. General errors should be stored in utils/errors.

1. All padding chars should be handled by convert package.

1. Move make, makePixelData, and makeSequence
from ivr/evr to convert

1. Write design_notes.md explaining how this works.

2. Figure out how to allow Hash32 or Hash64 as default
3. Add an fmi.dart file that allow packages
to write new FMI when encoding datasets.
4. Decide on the best way to handle:
    - version numbers
    - build numbers
6. Merge constants and primitives according to category
    - but constants and primitives in separate files?
    - remove anything that is not used.