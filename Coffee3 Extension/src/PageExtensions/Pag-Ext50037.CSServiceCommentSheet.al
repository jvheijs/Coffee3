pageextension 50037 CSServiceCommentSheet extends "Service Comment Sheet"
{
    layout
    {
        addlast(Control1)
        {
            field("CS Show on Invoice"; Rec."CS Show on Invoice")
            {
                ApplicationArea = All;
                Visible = IsInvoiceorOrder;
                Editable = IsInvoiceorOrder;
                Caption = 'Show on Invoice';
                ToolTip = 'Show comment on posted invoice report.';
            }
        }
    }
    var
        ServiceDocType: Enum "Service Document Type";
        IsInvoiceorOrder: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        SetIsInvoiceorOrder();
    end;

    trigger OnOpenPage()
    begin
        SetIsInvoiceorOrder();
    end;

    local procedure SetIsInvoiceorOrder()
    begin
        if (rec."Table Subtype" = ServiceDocType::Order) or (rec."Table Subtype" = rec."Table Subtype"::"0") then
            IsInvoiceorOrder := true
        else
            IsInvoiceorOrder := false;
    end;
}
