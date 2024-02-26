pageextension 50018 "CS Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter("Customer No.")
        {
            field(Rayon; Rec.Rayon)
            {
                ApplicationArea = All;
            }
            field(Routenummer; Rec.Routenummer)
            {
                ApplicationArea = All;
            }
        }
    }
}
