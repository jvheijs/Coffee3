table 50002 "Status History"
{
    Caption = 'Status History';

    fields
    {
        field(1; Regelnr; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; Klantnr; Code[10])
        {
            Caption = 'Customerno.';
        }
        field(3; "Status oud"; Code[10])
        {
            Caption = 'Status old';
        }
        field(4; "Status nieuw"; Code[10])
        {
            Caption = 'Status new';
        }
        field(5; "Datum wijziging"; Date)
        {
            Caption = 'Date Changing';
        }
        field(6; GebruikersID; Code[10])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(Key1; Regelnr)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

