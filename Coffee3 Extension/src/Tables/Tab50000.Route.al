table 50000 "Route"
{
    // CS1.0 160318 JHE : Gewijzigd.

    Caption = 'Rounds';

    fields
    {
        field(1; Regelnummer; Integer)
        {
            Caption = 'Linenumber';
        }
        field(2; Rayonnummer; Integer)
        {
            Caption = 'Area Number';
            TableRelation = "Area and Customerstatus".Rayoncode;
        }
        field(3; Routenummer; Integer)
        {
            Caption = 'Round Number';
        }
        field(4; Dropcode; Integer)
        {
            Caption = 'Dropcode';
        }
        field(5; Klantnummer; Code[10])
        {
            Caption = 'Customernumber';
            TableRelation = Customer."No." WHERE("No." = FIELD(Klantnummer));

            trigger OnValidate()
            begin
                // Kijken of er niet twee regels per klant aanwezig zijn
                route2.Reset;
                route2.SetRange(route2.Klantnummer, Klantnummer);
                if route2.Find('-') then
                    Error(Text60000 +
                          Text60001 +
                          Text60002 +
                          Text60003, route2.Rayonnummer, route2.Routenummer, route2.Dropcode);
            end;
        }
        field(6; Klantnaam; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Klantnummer)));
            Caption = 'Customername';
            Description = 'lengte gewijzigd ivm import 101000';
            FieldClass = FlowField;
        }
        field(7; Klantadres; Text[60])
        {
            CalcFormula = Lookup(Customer.Bezoekadres WHERE("No." = FIELD(Klantnummer)));
            Caption = 'Customer Address';
            FieldClass = FlowField;
        }
        field(8; Klantpostcode; Code[10])
        {
            CalcFormula = Lookup(Customer."Postcode bezoekadres" WHERE("No." = FIELD(Klantnummer)));
            Caption = 'Customer Post COde';
            FieldClass = FlowField;
            TableRelation = "Post Code".Code WHERE(Code = FIELD(Klantpostcode));
        }
        field(9; Klantplaats; Text[30])
        {
            CalcFormula = Lookup(Customer."Plaats bezoekadres" WHERE("No." = FIELD(Klantnummer)));
            Caption = 'Customercity';
            FieldClass = FlowField;
        }
        field(10; Postcodesorteren; Code[10])
        {
            Caption = 'Postcodesorteren';
        }
        field(11; dropcodenieuw; Integer)
        {
            Caption = 'Dropcode new';
        }
    }

    keys
    {
        key(Key1; Regelnummer)
        {
            Clustered = true;
        }
        key(Key2; Rayonnummer, Routenummer, Dropcode)
        {
        }
        key(Key3; Dropcode, Postcodesorteren)
        {
        }
        key(Key4; Postcodesorteren)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Routenummer)
        {
        }
    }

    trigger OnModify()
    begin
        wijzigen;
    end;

    var
        Text60000: Label 'Voor deze klant bestaat reeds een combinatie, namelijk\';
        Text60001: Label 'Rayon %1\';
        Text60002: Label 'Route %2\';
        Text60003: Label 'Dropcode %3\';
        klant: Record Customer;
        route2: Record Route;

    procedure wijzigen()
    begin
        klant.Reset;
        klant.SetRange(klant."No.", Klantnummer);
        if klant.Find('-') then begin
            klant.Rayon := Rayonnummer;
            klant.Routenummer := Routenummer;
            klant.Dropcode := Dropcode;
            klant."Last Date Modified" := WorkDate;
            klant.Modify;
        end;
    end;
}

