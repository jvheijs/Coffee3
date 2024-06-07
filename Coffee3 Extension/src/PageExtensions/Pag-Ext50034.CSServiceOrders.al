pageextension 50034 "CS Service Orders" extends "Service Orders"
{
    layout
    {
        addafter(Status)
        {
            field("Status Signing"; Rec."Status Signing")
            {
                ApplicationArea = All;
                ToolTip = 'Status Signing';
            }
        }
    }
}