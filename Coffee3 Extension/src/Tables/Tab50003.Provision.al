table 50003 "Provision"
{
    Caption = 'Provision';

    fields
    {
        field(1; Regelnummer; Integer)
        {
            Caption = 'Linenumber';
        }
        field(2; Datum; Date)
        {
            Caption = 'Date';
        }
        field(3; Rayon; Integer)
        {
            Caption = 'Area';
        }
        field(4; Route; Integer)
        {
            Caption = 'Round';
        }
        field(5; "Aantal adressen in route"; Integer)
        {
            Caption = 'Quantity Addresse in Round';
        }
        field(6; "Aantal gescoorde orders"; Integer)
        {
            Caption = 'Quantity Scored Orders';
        }
        field(10; "Aantal fulls adressen in route"; Integer)
        {
        }
        field(15; "Aantal serv adressen in route"; Integer)
        {
        }
        field(50000; "Nieuw aantal gescoorde orders"; Integer)
        {
            Caption = 'New Quantity Scored Orders';
        }
        field(60001; "Double Orders"; Integer)
        {
            Caption = 'Double Orders';
        }
        field(60002; "Service Orders"; Integer)
        {
            Caption = 'Service Orders';
        }
    }

    keys
    {
        key(Key1; Regelnummer)
        {
            Clustered = true;
        }
        key(Key2; Rayon, Route, Datum)
        {
        }
    }

    fieldgroups
    {
    }
}

