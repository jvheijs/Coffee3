pageextension 50007 "CS Item Card" extends "Item Card"
{
    layout
    {
        addafter("Use Cross-Docking")
        {
            field("Export Item"; Rec."Export Item")
            {
                ApplicationArea = All;
            }
        }
    }
}
