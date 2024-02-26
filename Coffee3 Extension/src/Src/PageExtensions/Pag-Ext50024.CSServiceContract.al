pageextension 50024 "CS Service Contract" extends "Service Contract"
{
    layout
    {
        addafter("No. of Posted Credit Memos")
        {
            field("Next Invoice Period Start"; Rec."Next Invoice Period Start")
            {
                ApplicationArea = All;
            }
            field("Next Invoice Period End"; Rec."Next Invoice Period End")
            {
                ApplicationArea = All;
            }

        }
        addbefore(Control1902018507)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5965),
                              "No." = FIELD("Contract No."),
                              "Document Type" = FIELD("Contract Type");
            }
        }
    }

}
