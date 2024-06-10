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

    actions
    {
        addafter("P&osting")
        {
            action(Unsign)
            {
                ApplicationArea = All;
                Caption = 'Unsign';
                ToolTip = 'Unsign';
                Image = Undo;
                trigger OnAction()
                begin
                    RecSignature.RemoveSignature(rec."No.", rec."Document Type".AsInteger(), database::"Service Header");
                    rec.UpdateSignStatus(false);
                    CurrPage.Update(false);
                end;
            }
        }

        addafter(Category_Category7)
        {
            actionref(UnSign_Promoted; Unsign)
            {
            }
        }
    }

    var
        RecSignature: Record "CS Signature";

}