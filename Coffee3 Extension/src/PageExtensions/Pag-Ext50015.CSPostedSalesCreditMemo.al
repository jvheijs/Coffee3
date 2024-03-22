pageextension 50015 "CS Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("Aantal colli"; Rec."Aantal colli")
            {
                ApplicationArea = All;
            }
        }
    }
}
