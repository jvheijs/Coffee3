<<<<<<< HEAD:Coffee3 Extension/src/Pages/Pag50012.DPSalesOrderLine.al
page 50012 "DP Sales Order Line"
{
    AutoSplitKey = true;
    Caption = 'Verkooporderregels';           // JvH-131023
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
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
                    Width = 4;
                }
                field(Stock; Rec.Stock)
                {
                    Width = 4;
                }
                field(Quantity; Rec.Quantity)
                {
                    Width = 4;
                    trigger OnValidate()
                    begin
                        rec.ValidateLineDiscountPercent(false);  // JvH-131023
                    end;
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

            group(DPSalesLineDetail)
            {
                caption = 'Verkooporderregels';              // JvH-131023
                Editable = false;

                field(Type1; 'Artikel')
                {
                    Caption = 'Soort';
                }
                field(ItemNo; ShowNo)
                {
                    Caption = 'Artikel nr.';                // JvH-131023
                    Lookup = false;
                    ToolTip = 'Specifies the item that is handled on the sales line.';

                    trigger OnDrillDown()
                    begin
                        SalesInfoPaneMgt.LookupItem(Rec);
                    end;
                }

                group(Orders)
                {
                    Caption = 'Beschikbaarheid';                // JvH-131023
                    field("Bst-Laatste"; Rec.LastOrder)
                    {
                        Caption = 'Verzenddatum';        // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Specifies when the items on the sales line must be shipped.';
                    }

                    field("Bst-Laatste-1"; Rec."LastOrder-1")
                    {
                        Caption = 'Artikelbeschikbaarheid';            // JvH-131023
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
                        Caption = 'Artikelvoorraad';              // JvH-131023
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
                group(DetailStock)
                {
                    Caption = 'Artikel';             // JvH-131023
                    field("Vrd-Laatste"; Rec."Stock-0")
                    {
                        Caption = 'Verzenddatum';                    // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Specifies when the items on the sales line must be shipped.';
                    }
                    field("Vrd-Laatste-1"; Rec."Stock-1")
                    {
                        Caption = 'Artikelbeschikbaarheid';              // JvH-131023
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
                        Caption = 'Artikelvoorraad';                    // JvH-131023
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

=======
page 50012 "DP Sales Order Line"
{
    AutoSplitKey = true;
    Caption = 'Verkooporderregels';           // JvH-131023
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
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
                    Width = 4;
                }
                field(Stock; Rec.Stock)
                {
                    Width = 4;
                }
                field(Quantity; Rec.Quantity)
                {
                    Width = 4;
                    trigger OnValidate()
                    begin
                        rec.ValidateLineDiscountPercent(false);  // JvH-131023
                    end;
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

            group(DPSalesLineDetail)
            {
                caption = 'Verkooporderregels';              // JvH-131023
                Editable = false;

                field(Type1; 'Artikel')
                {
                    Caption = 'Soort';
                }
                field(ItemNo; ShowNo)
                {
                    Caption = 'Artikel nr.';                // JvH-131023
                    Lookup = false;
                    ToolTip = 'Specifies the item that is handled on the sales line.';

                    trigger OnDrillDown()
                    begin
                        SalesInfoPaneMgt.LookupItem(Rec);
                    end;
                }

                group(Orders)
                {
                    Caption = 'Historie';                // JvH-131023
                    field("Bst-Laatste"; Rec.LastOrder)
                    {
                        Caption = 'Verkocht aantal';        // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Verkocht aantal per datum';
                    }

                    field("Bst-Laatste-1"; Rec."LastOrder-1")
                    {
                        Caption = 'Verkocht aantal 1';            // JvH-131023
                        DecimalPlaces = 0 : 0;
                        DrillDown = true;
                        ToolTip = 'Verkocht aantal per datum 1';

                        trigger OnDrillDown()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent);
                            CurrPage.Update(true);
                        end;
                    }
                    field("Bst-Laatste-2"; Rec."LastOrder-2")
                    {
                        Caption = 'Verkocht aantal 2';              // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Verkocht aantal per datum 2';
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
                group(DetailStock)
                {
                    Caption = 'Artikel';             // JvH-131023
                    field("Vrd-Laatste"; Rec."Stock-0")
                    {
                        Caption = 'Opgenomen voorraad';                    // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Opgenomen voorraad per datum';
                    }
                    field("Vrd-Laatste-1"; Rec."Stock-1")
                    {
                        Caption = 'Opgenomen voorraad 1';              // JvH-131023
                        DecimalPlaces = 0 : 0;
                        DrillDown = true;
                        ToolTip = 'Opgenomen voorraad per datum 1';

                        trigger OnDrillDown()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent);
                            CurrPage.Update(true);
                        end;
                    }
                    field("Vrd-Laatste-2"; Rec."Stock-2")
                    {
                        Caption = 'Opgenomen voorraad 2';                    // JvH-131023
                        DecimalPlaces = 0 : 0;
                        ToolTip = 'Opgenomen voorraad per datum 2';
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

>>>>>>> 5df8dd175afd15fe93c508fd4a5472bc4d629206:Coffee3 Extension/src/Src/Pages/Pag50012.DPSalesOrderLine.al
