tableextension 50017 "CS Service Invoice Header" extends "Service Invoice Header"
{
    Description = 'CS2.0';
    fields
    {
        field(50000; "Signature"; Blob)
        {
            Caption = 'Signature';
            Subtype = Bitmap;
            DataClassification = ToBeClassified;
        }

        field(50020; Verzendprofiel; Code[20])
        {
            Caption = 'Verzendprofiel';
            Description = 'CS1.0';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Document Sending Profile" where("No." = field("Customer No.")));
        }
    }
}
