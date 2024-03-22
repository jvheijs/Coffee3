tableextension 50009 "CS Sales Shipment Header" extends "Sales Shipment Header"
{
    Description = 'CS1.0';
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
        field(50009; "Signature"; Blob)
        {
            Caption = 'Signature';
            DataClassification = ToBeClassified;
        }

        field(50021; SalesPersonOrder; Boolean)
        {
            Description = 'COFF-1';
            Caption = 'VertegenwoordigersOrder';
            DataClassification = ToBeClassified;
        }
    }
}
