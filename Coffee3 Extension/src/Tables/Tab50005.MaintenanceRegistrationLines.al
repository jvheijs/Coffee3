table 50005 "Maintenance Registration Line"
{
    Caption = 'Maintenance Registration Line';

    fields
    {
        field(1; "Onderhoudsregistratie code"; Integer)
        {
            Caption = 'Maintenance Registration Code';
        }
        field(2; Klantnummer; Code[20])
        {
            Caption = 'Customernumber';
        }
        field(3; Regelnummer; Integer)
        {
            Caption = 'Linenumber';
        }
        field(4; Datum; Date)
        {
            Caption = 'Date';
        }
        field(5; Omschrijving; Text[30])
        {
            Caption = 'Description';
        }
        field(6; Gebruiker; Text[30])
        {
            Caption = 'User';
        }
        field(7; "Omschrijving 2"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Onderhoudsregistratie code", Klantnummer, Regelnummer)
        {
            Clustered = true;
        }
        key(Key2; Klantnummer, Datum, Regelnummer)
        {
        }
    }

    fieldgroups
    {
    }

    var
        regelrec: Record "Maintenance Registration Line";
}

