page 50018 "DP Sales Order Line#"
{
    AutoSplitKey = true;
    Caption = 'Sales Order Line';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where(Quantity = filter(<> 0));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000002)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                }
                field(Stock; Rec.Stock)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Store stock"; Rec."Store stock")
                {
                }
                field(Description; Rec.Description)
                {
                    Enabled = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Editable = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;

                trigger OnAction()
                var
                    lRecSalesHeader: Record "Sales Header";
                begin

                    // COFF-1
                    lRecSalesHeader.Get(lRecSalesHeader."Document Type"::Order, Rec."Document No.");
                    gCduCondor.gFncFillSalesLine(lRecSalesHeader);
                    // COFF-1
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item; // COFF-01.n
    end;

    var
        gCduCondor: Codeunit Condor;
}

