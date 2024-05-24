pageextension 50031 "CS Service Order Subform" extends "Service Order Subform"
{
    layout
    {
        addafter("Contract No.")
        {
            field("CS Service Contract Descr."; rec."CS Service Contract Descr.")
            {
                ApplicationArea = All;
                Caption = 'Service Contract Description';
                Editable = false;
                ToolTip = 'Service Contract Description';
            }
        }
    }
}
