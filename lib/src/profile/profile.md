# Profile

A _Profile_ is a specification that when
applied to a DICOM Information Object (DIO) (i.e. Study, Series, or SOP Instance) does the following:

1. Validates that each Element has valid _Values_.
2. De-Identifies the Elements contained in the DIO according to the rules specified in DICOM PS3.15 as updated by the profile.
3. Replaces all Dates with Normalized Dates.
4. Updates all Uids, that are not well known with new Uids.