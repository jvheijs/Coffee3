table 50006 "Export Terminal"
{
    Caption = 'Export terminal';

    fields
    {
        field(1; "Volgnr."; Integer)
        {
            Caption = 'Entryno.';
        }
        field(2; Omschrijving; Text[150])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Volgnr.")
        {
            Clustered = true;
        }
        key(Key2; Omschrijving)
        {
        }
    }

    fieldgroups
    {
    }
}

