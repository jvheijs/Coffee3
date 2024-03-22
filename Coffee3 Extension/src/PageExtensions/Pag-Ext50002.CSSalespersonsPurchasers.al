pageextension 50002 "CS Salespersons/Purchasers" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter("Phone No.")
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
