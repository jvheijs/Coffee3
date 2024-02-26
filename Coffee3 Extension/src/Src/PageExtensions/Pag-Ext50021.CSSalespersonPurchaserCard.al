pageextension 50021 "CS Salesperson/Purchaser Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("E-Mail")
        {
            field(Rayonfilter; Rec.Rayonfilter)
            {
                ApplicationArea = All;
            }
            field("No. Series"; Rec."No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
}
