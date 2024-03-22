table 50009 "Import Terminal"
{
    Caption = 'Import terminal';

    fields
    {
        field(1; Volgnummer; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry Number';
        }
        field(2; Omschrijving; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Factuurnummer; Code[10])
        {
            Caption = 'Invoicenumber';
        }
        field(4; Regelsoort; Code[2])
        {
            Caption = 'Linetype';
        }
        field(5; Factuur; Boolean)
        {
            Caption = 'Invoice';
        }
        field(6; Creditnota; Boolean)
        {
            Caption = 'Creditnota';
        }
        field(7; "Openstaande factuur gevonden"; Boolean)
        {
            Caption = 'Outstanding Invoice Found';
        }
    }

    keys
    {
        key(Key1; Volgnummer)
        {
            Clustered = true;
        }
        key(Key2; Regelsoort)
        {
        }
    }

    fieldgroups
    {
    }
}

