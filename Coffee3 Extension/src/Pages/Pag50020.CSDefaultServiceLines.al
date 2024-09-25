page 50020 "CS Default Service Lines"
{
    ApplicationArea = All;
    Caption = 'CS Default Service Lines';
    PageType = ListPart;
    SourceTable = "CS Default Service Lines";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Visible = false;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Description"; Rec."Description")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
