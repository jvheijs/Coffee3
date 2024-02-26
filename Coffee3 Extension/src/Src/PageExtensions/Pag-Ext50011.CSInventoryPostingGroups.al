pageextension 50011 "CS Inventory Posting Groups" extends "Inventory Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Service Item"; Rec."Service Item")
            {
                ApplicationArea = All;
            }

        }
    }
}
