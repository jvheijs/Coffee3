tableextension 50016 "CS Service Header" extends "Service Header"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; "Signature"; Blob)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
            SubType = Bitmap;
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
