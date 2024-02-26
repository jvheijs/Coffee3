tableextension 50012 "CS Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50005; Rayon; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Area';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Rayon WHERE("No." = FIELD("Customer No.")));
            Editable = false;
        }
        field(50006; Routenummer; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Round Number';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Routenummer WHERE("No." = FIELD("Customer No.")));
            Editable = false;
        }
    }
}
