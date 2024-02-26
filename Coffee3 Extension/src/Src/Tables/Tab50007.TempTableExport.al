table 50007 "Temp. Table Export"
{
    Caption = 'Temp. Table export';

    fields
    {
        field(1; Volgnummer; Integer)
        {
            Caption = 'Entry Number';
        }
        field(2; "Omschrijving terminal"; Text[40])
        {
            Caption = 'Description Terminal';
        }
        field(3; "Meenemen in export?"; Boolean)
        {
            Caption = 'Attach in export?';
        }
        field(4; Geexporteerd; Boolean)
        {
            Caption = 'Exported';
        }
        field(5; "Laatste mut-export klanten"; Date)
        {
            Caption = 'Last mut-export customers';
        }
        field(6; "Laatste mut-export artikelen"; Date)
        {
            Caption = 'Last mut-export item';
        }
        field(7; "Laatste mut-export voorraad mu"; Date)
        {
            Caption = 'Last mut-export Inventory';
        }
        field(8; "Laatste mut-export openst.post"; Date)
        {
            Caption = 'Last mut-export Entries';
        }
        field(48; "actieve artikelen exporteren"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Volgnummer)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

