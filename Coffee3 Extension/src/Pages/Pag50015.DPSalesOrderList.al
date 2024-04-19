page 50015 "DP SalesOrderList"
{
    Caption = 'Sales Order List';
    CardPageID = "DP Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field(Rayon; Rec.Rayon)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Open)
            {
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "DP Sales Order";
            }
        }
    }

    trigger OnOpenPage()
    var
        lCduCondor: Codeunit Condor;
    begin
        Rec.FilterGroup(10);
        Rec.SetFilter("Location Code", lCduCondor.gFncRayonFilter());
        Rec.FilterGroup(0);
    end;
}

