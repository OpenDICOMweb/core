
BytesBase (abstract)
    Bytes (abstract) implement

    BytesBE extends Bytes with BigEndianMixin
        GrowableBytesBE extends BytesBE with GrowableMixin
        DicomBytesBE extends BytesBE with DicomMixin
            GrowableDicomBytesLE extends DicomBytesBE with GrowableMixin        
    BytesLE extends Bytes with LittleEndianMixin
        GrowableBytesLE extends BytesLE with GrowableMixin
        DicomBytesLE extends BytesBE with DicomMixin
            DicomGrowableBytesLE extends DicomBytesBE with GrowableMixin
        
     A DicomBytes(abstract) extends Bytes with DicomMixin