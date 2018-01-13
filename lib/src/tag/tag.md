**OpenDICOM<em>web</em> SDK**
# Tag - The Semantic Identifier for an Element

Tags define:

- **code**:* a 32-bit integer
- **value representation(VR)**: The data type of the Tag.
- **value multiplicity(VM)**: The number and shape of the value(s) of the Tag.
- **keyword**: an unique string that satisfies the regular expression ^\[A-Za-z\]{1}\w*$
- **name**: a short description of the meaning of the Tag.
- **isRetired**: A boolean value indicating whether the Tag has been retired.
- **type**: The default presence requirement for the Tag.

## Types of Tags

- Tag
- Public (DICOM) Tags
    - Known (code, vr, vm, keyword, name, isRetired, [EType = EType.k3])
        - Retired (DICOM Defined, but retired)
        - Group Length (gggg,0000) (code)
            - vr = VR.kUL
            - vm = VM.k1
            - keyword = "GroupLengthTag"
            - name = "Group Length Tag"
            - isRetired = true
            - EType = EType.k3
    - Unknown(code, vr)
        - vr = VR.kUN
        - vm = VM.k1_n
        - keyword = "UnknownPublicTag"
        - name = "Unknown Public Tag"
        - isRetired = true
        - type = EType.k3
- Private Tags
    - Creator
        - Known(code, vr, vm, name)
            - type = EType.k3
        - Unknown(code, \[vr = VR.kUN\])
            - vm = VM.k1_n
            - keyword = "UnknownPrivateCreatorTag"
            - name = "Unknown Private Creator Tag"
            - isRetired = false
            - type = EType.k3
    - Private Data (code, vr, vm, name, creatorName)
        - Known (code, vr, vm, name, creatorName)
        - Unknown (code, \[vr = VR.kUN, creatorName = "Unknown Creator"\]\])
            - vm = VM.k1_n
            - keyword = "UnknownPrivateDataTag"
            - name = "Unknown Private Data Tag"
            - isRetired = false
            - type = EType.k3

    - Other
        - Private Group Length (pppp,0000)
        - Private Illegal (pppp,0001 - pppp,000F)
        - Private Data W/O Creator
## Public Tags

- Defined by [the DICOM Standard][DICOM]
- Identified by a _code_ (a 32-bit integer) or a _keyword_
- The _code_ is always an even integer.



# Issues with Data Elements

| Keyword | Type | Description
- Retired
- Invalid Public Tag


[DICOM]:http://dicom.nema.org/standard.html
