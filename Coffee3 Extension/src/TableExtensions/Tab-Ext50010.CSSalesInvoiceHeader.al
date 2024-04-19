tableextension 50010 "CS Sales Invoice Header" extends "Sales Invoice Header"
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
        field(50009; "Remboursformulier geprint"; Boolean)
        {
            Description = '2000-901-51';
            Caption = 'COD Form Printed';
            DataClassification = ToBeClassified;
        }
        field(50015; Afhalen; Boolean)
        {
            Caption = 'Collect';
            DataClassification = ToBeClassified;
        }
        field(50020; Verzendprofiel; Code[20])
        {
            Description = 'CS1.0';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Document Sending Profile" where("No." = field("Sell-to Customer No.")));
        }
        field(50021; SalesPersonOrder; Boolean)
        {
            Description = 'COFF-1';
            Caption = 'VertegenwoordigersOrder';
            DataClassification = ToBeClassified;
        }
        field(50050; "CS Bill-to Customer No."; Code[20])
        {
            Description = 'Mirror the Bill-to Customer No. field in order to add to the custom keys.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Editable = false;
        }
        field(50051; "CS Shipment Date"; Date)
        {
            Description = 'Mirror the Shipment Date field in order to add to the custom keys.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50041; "Signature"; Blob)
        {
            Caption = 'Signature';
            Subtype = Bitmap;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {

        key(CSKey1; "CS Bill-to Customer No.", "CS Shipment Date")
        {

        }
    }
}
