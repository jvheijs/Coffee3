pageextension 50028 "CS Service Contracts" extends "Service Contracts"
{
    Editable = true;

    layout
    {
        addafter("Last Price Update Date")
        {
            field("Next Invoice Period Start"; Rec."Next Invoice Period Start")
            {
                ApplicationArea = All;
            }
            field("Next Invoice Period End"; Rec."Next Invoice Period End")
            {
                ApplicationArea = All;
            }
            field("Next Invoice Date"; Rec."Next Invoice Date")
            {
                ApplicationArea = All;
            }
            field("Last Invoice Date"; Rec."Last Invoice Date")
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
