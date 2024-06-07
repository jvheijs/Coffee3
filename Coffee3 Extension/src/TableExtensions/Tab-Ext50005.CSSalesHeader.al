tableextension 50005 "CS Sales Header" extends "Sales Header"
{
    Description = 'CS1.0,CS1.1,CS2.0';
    fields
    {
        field(50005; Rayon; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Area';
            DataClassification = ToBeClassified;
        }
        field(50006; Routenummer; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Round Number';
            DataClassification = ToBeClassified;
        }
        field(50008; "Aantal colli"; Decimal)
        {
            Description = '2000-901-55';
            Caption = 'Quantity Packages';
            DataClassification = ToBeClassified;
        }
        field(50013; "Tijd terminal"; Time)
        {
            Description = '2000-901-47';
            Caption = 'Time Terminal';
            DataClassification = ToBeClassified;
        }
        field(50014; "PDT-lijst afgedrukt"; Boolean)
        {
            Description = '2000-903-01';
            Caption = 'PDT-lijst afgedrukt';
            DataClassification = ToBeClassified;
        }
        field(50015; Afhalen; Boolean)
        {
            Description = '2000-902-04 (versie 2)';
            Caption = 'Collect';
            DataClassification = ToBeClassified;
        }
        field(50017; imported; Boolean)
        {
            Caption = 'Imported';
            Description = 'ADB 2012-03-07';
            DataClassification = ToBeClassified;
        }
        field(50020; Verzendprofiel; Code[20])
        {
            caption = 'Document Sending Profile';
            Description = 'CS1.0';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Document Sending Profile" where("No." = field("Sell-to Customer No.")));
        }
        field(50021; SalesPersonOrder; Boolean)
        {
            Description = 'COFF-1';
            DataClassification = ToBeClassified;
        }
        field(50022; InPosting; Boolean)
        {
            Description = 'COFF-1';
            DataClassification = ToBeClassified;
        }
        field(50040; "CS Posting Date"; Date)
        {
            Caption = 'CS Posting Date';
            Description = 'Mirror the Posting Date field in order to add to the custom keys.';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50041; "Signature"; Blob)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
            SubType = Bitmap;
            ObsoleteState = pending;
            ObsoleteReason = 'Obsolete because the signature is now stored in the CS Signature table.';
        }

    }

    keys
    {

        key(CSKey1; Rayon, Routenummer, "CS Posting Date")
        {

        }
    }

}
