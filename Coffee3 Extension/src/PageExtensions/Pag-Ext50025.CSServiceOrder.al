pageextension 50025 "CS Service Order" extends "Service Order"
{
    layout
    {
        addafter(Status)
        {
            field("Status Signing"; Rec."Status Signing")
            {
                ApplicationArea = All;
                ToolTip = 'Status Signing';
                Editable = SignatureStatusEditable;
            }

            field("CSSignature"; RecSignature."Signature")
            {
                Caption = 'Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify(Invoicing)
        {
            Visible = false;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        modify(" Foreign Trade")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter("P&osting")
        {
            action(Sign)
            {
                ApplicationArea = All;
                Caption = 'Sign';
                ToolTip = 'Sign';
                Image = Signature;
                trigger OnAction()
                begin
                    AddSignature();
                    HasSignature();
                    UpdateSignStatus(true);
                end;
            }
        }

        addafter(Category_Category7)
        {
            actionref(Sign_Promoted; Sign)
            {
            }
        }
    }

    var
        RecSignature: Record "CS Signature";

    trigger OnAfterGetRecord()
    begin
        SignatureStatusEditable := HasSignature();
    end;

    var
        SignatureStatusEditable: Boolean;

    local procedure HasSignature(): Boolean;
    begin
        if RecSignature.GET(database::"Service Header", rec."No.", rec."Document Type".AsInteger()) then
            RecSignature.CalcFields("Signature");
        exit(RecSignature.Signature.HasValue());
    end;

    local procedure AddSignature();
    var
        Signature: Page Signature;
    begin
        Signature.SetDocNo(rec."No.");
        Signature.SetDocType(rec."Document Type".AsInteger());
        Signature.SetTable(Database::"Service Header");
        Signature.SetWithExit();
        Signature.RunModal();
    end;

    local procedure UpdateSignStatus(Signed: Boolean)
    begin
        if Signed then
            rec."Status Signing" := rec."Status Signing"::Signed
        else
            rec."Status Signing" := rec."Status Signing"::Unsigned;
        rec.Modify();
    end;
}
