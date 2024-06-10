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

    procedure HasSignature(ForDocNo: Code[20]; ForDocType: Integer; ForSourceTableNo: Integer): Boolean
    begin
        if GET(ForSourceTableNo, ForDocNo, ForDocType) then
            CalcFields("Signature");
        exit(Signature.HasValue());
    end;

    procedure OpenSignaturePage(ForDocNo: Code[20]; ForDocType: Integer; ForSourceTableNo: Integer);
    var
        PageSignature: Page Signature;
    begin
        PageSignature.SetDocNo(ForDocNo);
        PageSignature.SetDocType(ForDocType);
        PageSignature.SetTable(ForSourceTableNo);
        PageSignature.SetWithExit();
        PageSignature.RunModal();
    end;

    procedure RemoveSignature(ForDocNo: Code[20]; ForDocType: Integer; ForSourceTableNo: Integer): Boolean
    var
        SignatureDelete: Record "CS Signature";
    begin
        if SignatureDelete.GET(ForSourceTableNo, ForDocNo, ForDocType) then
            SignatureDelete.delete();
    end;
}
