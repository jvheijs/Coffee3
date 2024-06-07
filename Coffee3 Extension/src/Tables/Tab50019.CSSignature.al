table 50019 "CS Signature"
{
    Caption = 'Signature';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Document Type"; Integer)
        {
            Caption = 'Dococument Type';
        }
        field(4; "Signature"; Blob)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
            SubType = Bitmap;
        }
    }
    keys
    {
        key(PK; "Table No.", "Document No.", "Document Type")
        {
            Clustered = true;
        }
    }
}
