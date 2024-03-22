page 50016 "DP Sales Line FactBox"
{
    Caption = 'Sales Line Details';
    PageType = CardPart;
    SourceTable = "Sales Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Type; 'Artikel')
            {
                Caption = 'Soort';
            }
            field(ItemNo; ShowNo)
            {
                Caption = 'Item No.';
                Lookup = false;
                ToolTip = 'Specifies the item that is handled on the sales line.';

                trigger OnDrillDown()
                begin
                    SalesInfoPaneMgt.LookupItem(Rec);
                end;
            }
            group(Orders)
            {
                Caption = 'Availability';
                field("Bst-Laatste"; Rec.LastOrder)
                {
                    Caption = 'Shipment Date';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies when the items on the sales line must be shipped.';
                }
                field("Bst-Laatste-1"; Rec."LastOrder-1")
                {
                    Caption = 'Item Availability';
                    DecimalPlaces = 0 : 0;
                    DrillDown = true;
                    ToolTip = 'Specifies how may units of the item on the sales line are available, in inventory or incoming before the shipment date.';

                    trigger OnDrillDown()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent);
                        CurrPage.Update(true);
                    end;
                }
                field("Bst-Laatste-2"; Rec."LastOrder-2")
                {
                    Caption = 'Available Inventory';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
                }
                field(DateLastOrder; Rec.DateLastOrder)
                {
                    Caption = 'Datum';
                }
                field("DateLastOrder-1"; Rec."DateLastOrder-1")
                {
                    Caption = 'Datum-1';
                }
                field("DateLastOrder-2"; Rec."DateLastOrder-2")
                {
                    Caption = 'Datum-2';
                }
            }
            group(Stock)
            {
                Caption = 'Item';
                field("Vrd-Laatste"; Rec."Stock-0")
                {
                    Caption = 'Shipment Date';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies when the items on the sales line must be shipped.';
                }
                field("Vrd-Laatste-1"; Rec."Stock-1")
                {
                    Caption = 'Item Availability';
                    DecimalPlaces = 0 : 0;
                    DrillDown = true;
                    ToolTip = 'Specifies how may units of the item on the sales line are available, in inventory or incoming before the shipment date.';

                    trigger OnDrillDown()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent);
                        CurrPage.Update(true);
                    end;
                }
                field("Vrd-Laatste-2"; Rec."Stock-2")
                {
                    Caption = 'Available Inventory';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
                }
                field("DateStock-0"; Rec."DateStock-0")
                {
                    Caption = 'Datum';
                }
                field("DateStock-1"; Rec."DateStock-1")
                {
                    Caption = 'Datum-1';
                }
                field("DateStock-2"; Rec."DateStock-2")
                {
                    Caption = 'Datum-2';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Reserved Quantity");
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    local procedure ShowNo(): Code[20]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec."No.");
    end;
}

