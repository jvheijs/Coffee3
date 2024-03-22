pageextension 50016 "CS Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Posting Date")
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
