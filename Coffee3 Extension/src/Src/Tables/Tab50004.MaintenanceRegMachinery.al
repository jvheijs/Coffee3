table 50004 "Maintenance Reg. Machinery"
{
    Caption = 'Maintenance Registr. Machinery';
    DrillDownPageID = "Maint. Reg. Machinery List";
    LookupPageID = "Maint. Reg. Machinery List";

    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
        }
        field(2; Klantnummer; Code[20])
        {
            Caption = 'Customernumber';
            Editable = false;
            TableRelation = Customer."No." WHERE("No." = FIELD(Klantnummer));
        }
        field(3; Klantnaam; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Klantnummer)));
            Caption = 'Customername';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Type apparaat"; Code[10])
        {
            Caption = 'Machine Type';
            TableRelation = Item;

            trigger OnValidate()
            begin
                ArtRec.Get("Type apparaat");
                //IF ArtRec."Type artikel" <> ArtRec."Type artikel"::"0" THEN
                //  ERROR(Text60000);
            end;
        }
        field(5; Serienummer; Text[10])
        {
            Caption = 'Serial Nos.';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(6; Opvoerdatum; Date)
        {
            Caption = 'Entry Date';
        }
        field(7; Nummer; Integer)
        {
            Caption = 'Number';
        }
        field(8; "Omschrijving apparaat"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Type apparaat")));
            Caption = 'Description Machine';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Actief; Boolean)
        {
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; Klantnummer, "Code")
        {
            Clustered = true;
        }
        key(Key2; Serienummer)
        {
        }
        key(Key3; "Type apparaat")
        {
        }
        key(Key4; Nummer)
        {
        }
        key(Key5; Klantnummer, Opvoerdatum)
        {
        }
        key(Key6; Klantnummer, Actief)
        {
        }
        key(Key7; Klantnummer, Serienummer)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        OnderhoudsregelsRec.SetRange(Klantnummer, Klantnummer);
        OnderhoudsregelsRec.SetRange("Onderhoudsregistratie code", Code);
        OnderhoudsregelsRec.DeleteAll;
    end;

    var
        OnderhoudsRec: Record "Maintenance Reg. Machinery";
        OnderhoudsregelsRec: Record "Maintenance Registration Line";
        ArtRec: Record Item;
        "Nieuwe Code": Integer;
        Text60000: Label 'Dit is geen artikel van type apparaat.';
}

