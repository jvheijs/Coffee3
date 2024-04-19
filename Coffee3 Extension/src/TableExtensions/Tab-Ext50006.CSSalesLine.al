tableextension 50006 "CS Sales Line" extends "Sales Line"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; Stock; Integer)
        {
            Description = 'COFF-1';
            Caption = 'Voorraad';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Stock = 0) and "Store stock" then
                    "Store stock" := false
                else
                    if (Stock = 0) and not "Store stock" then
                        "Store stock" := true;
                if Stock > 0 then
                    "Store stock" := true;
            end;
        }
        field(50001; "Store stock"; Boolean)
        {
            Description = 'COFF-1';
            Caption = 'Voorraad opslaan';
            DataClassification = ToBeClassified;
        }
        field(50002; LastOrder; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Laatste bestelling';
            DataClassification = ToBeClassified;
        }
        field(50003; "LastOrder-1"; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Laatste bestelling-1';
            DataClassification = ToBeClassified;
        }
        field(50004; "LastOrder-2"; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Laatste bestelling-2';
            DataClassification = ToBeClassified;
        }
        field(50005; "Stock-0"; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Voorraad';
            DataClassification = ToBeClassified;
        }
        field(50006; "Stock-1"; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Voorraad-1';
            DataClassification = ToBeClassified;
        }
        field(50007; "Stock-2"; Decimal)
        {
            Description = 'COFF-1';
            Caption = 'Voorraad-2';
            DataClassification = ToBeClassified;
        }
        field(50020; DateLastOrder; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum laatste bestelling';
            DataClassification = ToBeClassified;
        }
        field(50021; "DateLastOrder-1"; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum laatste bestelling-1';
            DataClassification = ToBeClassified;
        }
        field(50022; "DateLastOrder-2"; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum laatste bestelling-2';
            DataClassification = ToBeClassified;
        }
        field(50023; "DateStock-0"; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum voorraad';
            DataClassification = ToBeClassified;
        }
        field(50024; "DateStock-1"; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum voorraad-1';
            DataClassification = ToBeClassified;
        }
        field(50025; "DateStock-2"; Date)
        {
            Description = 'COFF-1';
            Caption = 'Datum voorraad-2';
            DataClassification = ToBeClassified;
        }
    }
}
