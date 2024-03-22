table 50001 "Area and Customerstatus"
{
    Caption = 'Area and Customerstatus';
    DrillDownPageID = "Areas and Customerstatusses";
    LookupPageID = "Areas and Customerstatusses";

    fields
    {
        field(1; Rayoncode; Integer)
        {
            Caption = 'Area Code';
        }
        field(2; "Omschrijving rayon"; Text[30])
        {
            Caption = 'Description Area';
        }
        field(3; Statuscode; Code[10])
        {
            Caption = 'Statuscode';
        }
        field(4; "Omschrijving status"; Text[30])
        {
            Caption = 'Description Status';
        }
    }

    keys
    {
        key(Key1; Rayoncode, Statuscode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Rayoncode, "Omschrijving rayon")
        {
        }
    }
}

