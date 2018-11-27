
Bytes (abstract)
    A DicomBytes extends Bytes with DicomMixin
    BytesBE extends Bytes with BigEndianMixin
        GrowableBytesBE extends BytesBE with GrowableMixin
        DicomBytesBE extends BytesBE with DicomMixin
            GrowableDicomBytesLE extends DicomBytesBE with GrowableMixin        
    BytesLE extends Bytes with LittleEndianMixin
        GrowableBytesLE extends BytesLE with GrowableMixin
        DicomBytesLE extends BytesBE with DicomMixin
            DicomGrowableBytesLE extends DicomBytesBE with GrowableMixin
        
    