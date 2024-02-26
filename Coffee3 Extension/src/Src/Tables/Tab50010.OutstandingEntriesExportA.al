table 50010 "Outstanding Entries Export A"
{
    Caption = 'Outstanding Entries Export A';

    fields
    {
        field(1; "Klantnr."; Code[6])
        {
            Caption = 'Customerno.';
        }
        field(2; "Factuurnr."; Code[7])
        {
            Caption = 'Invoiceno.';
        }
        field(3; "Factuur datum"; Date)
        {
            Caption = 'Invoice date';
        }
        field(4; "Openstaand bedrag"; Decimal)
        {
            Caption = 'Outstanding Amount';
        }
        field(5; "Aantal aanmaningen"; Integer)
        {
            Caption = 'Quantity Reminders';
        }
    }

    keys
    {
        key(Key1; "Klantnr.")
        {
            Clustered = true;
        }
        key(Key2; "Factuurnr.")
        {
        }
    }

    fieldgroups
    {
    }
}

