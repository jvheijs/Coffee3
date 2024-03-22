table 50008 "Inventory Export"
{
    Caption = 'Inventory Export';

    fields
    {
        field(1; "Artikelnr."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; Aantal; Integer)
        {
            Caption = 'Quantity';
        }
        field(3; Positief; Text[1])
        {
            Caption = 'Positive';
        }
    }

    keys
    {
        key(Key1; "Artikelnr.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

