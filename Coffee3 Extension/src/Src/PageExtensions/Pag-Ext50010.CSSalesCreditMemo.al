pageextension 50010 "CS Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Name 2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = All;
            }
        }
    }
}
