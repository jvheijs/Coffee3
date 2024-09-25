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
                ToolTip = 'Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter("Contract No.")
        {
            field("CS Location Code"; Rec."Location Code")
            {
                ApplicationArea = Location;
                ToolTip = 'Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.';
            }
        }

        modify(Invoicing)
        {
            Visible = FasttabVisible;
        }
        modify(Shipping)
        {
            Visible = FasttabVisible;
        }
        modify(Details)
        {
            Visible = FasttabVisible;
        }
        modify(" Foreign Trade")
        {
            Visible = FasttabVisible;
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
                    RecSignature.OpenSignaturePage(rec."No.", rec."Document Type".AsInteger(), database::"Service Header");
                    if RecSignature.get(database::"Service Header", rec."No.", rec."Document Type".AsInteger()) then
                        rec.UpdateSignStatus(true);
                    CurrPage.Update(false);
                end;
            }

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
            actionref(Sign_Promoted; Sign)
            {
            }
            actionref(UnSign_Promoted; Unsign)
            {
            }
        }
    }

    var
        RecSignature: Record "CS Signature";

    trigger OnOpenPage()
    begin
        SetFastTabVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        SignatureStatusEditable := RecSignature.get(database::"Service Header", rec."No.", rec."Document Type".AsInteger());
        RecSignature.CalcFields(Signature);
        SetFastTabVisibility();
    end;

    var
        SignatureStatusEditable: Boolean;
        FasttabVisible: Boolean;

    local procedure SetFastTabVisibility()
    var
        WarehouseEmployee: Record "Warehouse Employee";

    begin
        WarehouseEmployee.SetRange("User ID", UserId());
        FasttabVisible := WarehouseEmployee.IsEmpty();
    end;
}
