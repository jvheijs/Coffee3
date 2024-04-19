codeunit 50000 "Condor"
{

    trigger OnRun()
    begin

        gFncFillMyCustomer();
        // lFncTestEnv();
    end;

    var
    procedure gFncFillMyCustomer()
    var
        lRecUser: Record User;
        lRecSalespersonPurchaser: Record "Salesperson/Purchaser";
        lRecCustomer: Record Customer;
        lRecMyCustomer: Record "My Customer";
        lRecShiptoAddress: Record "Ship-to Address";
    begin

        // COFF-1.ns

        // lRecUser.SETFILTER("User Name",'@'+USERID);
        lRecMyCustomer.DELETEALL();
        lRecUser.FindSet();
        repeat
            // MESSAGE('xxx %1 %2', lRecUser."User Name",lRecUser."Contact Email");
            if lRecUser."Contact Email" <> '' then begin
                lRecSalespersonPurchaser.SETFILTER("E-Mail", lRecUser."Contact Email");
                if lRecSalespersonPurchaser.FindFirst() then
                    if lRecSalespersonPurchaser.Rayonfilter <> '' then begin
                        lRecMyCustomer.SETFILTER("User ID", USERID);

                        lRecCustomer.SETFILTER(Rayon, lRecSalespersonPurchaser.Rayonfilter);
                        if lRecCustomer.FINDSET() then
                            repeat
                                lRecMyCustomer."User ID" := lRecUser."User Name";
                                lRecMyCustomer."Customer No." := lRecCustomer."No.";
                                lRecMyCustomer.Name := lRecCustomer.Name;
                                lRecMyCustomer."Phone No." := lRecCustomer."Phone No.";
                                lRecShiptoAddress.SETFILTER("Customer No.", lRecCustomer."No.");
                                lRecShiptoAddress.SETFILTER(Code, 'BEZOEK');
                                if lRecShiptoAddress.FINDFIRST() then begin
                                    lRecMyCustomer.Bezoekadres := copystr(lRecShiptoAddress.Address, 1, 60);
                                    lRecMyCustomer."Postcode bezoekadres" := copystr(lRecShiptoAddress."Post Code", 1, 10);
                                    lRecMyCustomer."Plaats bezoekadres" := lRecShiptoAddress.City;
                                end else begin
                                    lRecMyCustomer.Bezoekadres := copystr(lRecCustomer.Address, 1, 60);
                                    lRecMyCustomer."Postcode bezoekadres" := copystr(lRecCustomer."Post Code", 1, 10);
                                    lRecMyCustomer."Plaats bezoekadres" := lRecCustomer.City;
                                end;
                                lRecMyCustomer."GSM-nummer" := lRecCustomer."GSM-nummer";
                                lRecMyCustomer.Klantstatus := lRecCustomer.Klantstatus;
                                lRecMyCustomer.Rayon := lRecCustomer.Rayon;
                                lRecMyCustomer.Routenummer := lRecCustomer.Routenummer;
                                lRecMyCustomer.Dropcode := lRecCustomer.Dropcode;
                                lRecMyCustomer."Cust.Memo1" := lRecCustomer."Cust.Memo1";
                                lRecMyCustomer."Cust.Memo2" := lRecCustomer."Cust.Memo2";
                                lRecMyCustomer."Mark 01" := lRecCustomer."Mark 01";
                                lRecMyCustomer."Mark 02" := lRecCustomer."Mark 02";
                                lRecMyCustomer."Mark 03" := lRecCustomer."Mark 03";
                                lRecMyCustomer.Bevyz := lRecCustomer.Bevyz;
                                lRecMyCustomer."Partner Type Org" := lRecCustomer."Partner Type Org";
                                lRecMyCustomer.INSERT();
                            until lRecCustomer.NEXT() = 0;
                    end;
            end;
        until lRecUser.NEXT() = 0;

        // COFF-1.ne
    end;


    procedure gFncRayonFilter(): Text
    var
        lRecUser: Record User;
        lRecSalespersonPurchaser: Record "Salesperson/Purchaser";
    begin

        // COFF-1.ns
        lRecUser.SETFILTER("User Name", '@' + USERID);
        lRecUser.FINDFIRST();
        lRecSalespersonPurchaser.SETFILTER("E-Mail", lRecUser."Contact Email");
        if lRecSalespersonPurchaser.FindFirst() then
            exit(lRecSalespersonPurchaser.Rayonfilter);
        // COFF-1.ne
        ERROR('U heeft geen rayonfilter.');
    end;


    procedure gFncFillSalesLine(pRecSalesHeader: Record "Sales Header")
    var
        lRecInventoryPostingGroup: Record "Inventory Posting Group";
        lRecSalesReceivablesSetup: Record "Sales & Receivables Setup";
        lRecSalesInvoiceLine: Record "Sales Invoice Line";
        lRecItem: Record Item;
        lRecSalesLine: Record "Sales Line";
        lRecSalesLine1: Record "Sales Line";
        lRecCustStock: Record "Cust. Stock";
        lIntLineNo: Integer;
    begin

        // COFF-1
        lRecSalesReceivablesSetup.FINDFIRST();

        // Normale artikelen
        lRecCustStock.SETFILTER("Cust. No.", pRecSalesHeader."Sell-to Customer No.");
        lRecCustStock.SETFILTER("Check Date", FORMAT(CALCDATE(lRecSalesReceivablesSetup."Max. Historie Time", WORKDATE())) + '..');
        if lRecCustStock.FindSet() then
            repeat
                if lRecItem.GET(lRecCustStock."Item No.") then
                    if not lRecInventoryPostingGroup.GET(lRecItem."Inventory Posting Group") then lRecInventoryPostingGroup.INIT();
                if not lRecInventoryPostingGroup."Service Item" then begin
                    lRecSalesLine1.SETRANGE("Document Type", pRecSalesHeader."Document Type");
                    lRecSalesLine1.SETRANGE("Document No.", pRecSalesHeader."No.");
                    lRecSalesLine1.SETRANGE(Type, lRecSalesLine1.Type::Item);
                    lRecSalesLine1.SETFILTER("No.", lRecCustStock."Item No.");
                    if not lRecSalesLine1.FINDSET() then begin
                        lRecSalesLine.VALIDATE("Document Type", pRecSalesHeader."Document Type");
                        lRecSalesLine.VALIDATE("Document No.", pRecSalesHeader."No.");
                        lIntLineNo += 10000;
                        lRecSalesLine.VALIDATE("Line No.", lIntLineNo);
                        lRecSalesLine.VALIDATE("Sell-to Customer No.", pRecSalesHeader."Sell-to Customer No.");
                        lRecSalesLine.VALIDATE(Type, lRecSalesLine.Type::Item);
                        lRecSalesLine.VALIDATE("No.", lRecCustStock."Item No.");
                        lRecSalesLine.INSERT();
                    end;
                end;
            until lRecCustStock.NEXT() = 0;

        // Service artikelen
        lIntLineNo += 10000;
        lRecSalesLine.VALIDATE("Document Type", pRecSalesHeader."Document Type");
        lRecSalesLine.VALIDATE("Document No.", pRecSalesHeader."No.");
        lIntLineNo += 10000;
        lRecSalesLine.VALIDATE("Line No.", lIntLineNo);
        lRecSalesLine.VALIDATE("Sell-to Customer No.", pRecSalesHeader."Sell-to Customer No.");
        lRecSalesLine.VALIDATE(Type, 0);
        lRecSalesLine.VALIDATE(Description, '---- Service artikelen');
        lRecSalesLine.INSERT();
        /*
        // Op basis van klant voorraad
        lRecCustStock.SETFILTER("Cust. No.","Sell-to Customer No.");
        lRecCustStock.SETFILTER("Check Date",FORMAT(CALCDATE(lRecSalesReceivablesSetup."Max. Historie Time",WORKDATE()))+'..');
        if lRecCustStock.FINDFIRST() THEN
        REPEAT
            if lRecItem.GET(lRecCustStock."Item No.") THEN
            if NOT lRecInventoryPostingGroup.GET(lRecItem."Inventory Posting Group") THEN lRecInventoryPostingGroup.INIT();
            if lRecInventoryPostingGroup."Service Item" THEN BEGIN
            lRecSalesLine1.SETRANGE("Document Type",pRecSalesHeader."Document Type");
            lRecSalesLine1.SETRANGE("Document No.",pRecSalesHeader."No.");
            lRecSalesLine1.SETRANGE(Type,lRecSalesLine1.Type::Item);
            lRecSalesLine1.SETFILTER("No.",lRecCustStock."Item No.");
            if NOT lRecSalesLine1.FINDSET() THEN BEGIN
                lRecSalesLine.VALIDATE("Document Type","Document Type");
                lRecSalesLine.VALIDATE("Document No.","No.");
                lIntLineNo += 10000;
                lRecSalesLine.VALIDATE("Line No.",lIntLineNo);
                lRecSalesLine.VALIDATE("Sell-to Customer No.","Sell-to Customer No.");
                lRecSalesLine.VALIDATE(Type,lRecSalesLine.Type::Item);
                lRecSalesLine.VALIDATE("No.",lRecCustStock."Item No.");
                lRecSalesLine.INSERT();
            END;
            END;
        UNTIL lRecCustStock.NEXT() =0 ;
        */
        //
        lRecSalesInvoiceLine.SETFILTER("Sell-to Customer No.", pRecSalesHeader."Sell-to Customer No.");
        lRecSalesInvoiceLine.SETFILTER("Posting Date", FORMAT(CALCDATE(lRecSalesReceivablesSetup."Max. Historie Time", WORKDATE())) + '..');
        if lRecSalesInvoiceLine.FINDSET() then
            repeat
                lRecInventoryPostingGroup.INIT();
                if lRecItem.GET(lRecSalesInvoiceLine."No.") then
                    if not lRecInventoryPostingGroup.GET(lRecItem."Inventory Posting Group") then lRecInventoryPostingGroup.INIT();
                if lRecInventoryPostingGroup."Service Item" then begin
                    lRecSalesLine1.SETRANGE("Document Type", pRecSalesHeader."Document Type");
                    lRecSalesLine1.SETRANGE("Document No.", pRecSalesHeader."No.");
                    lRecSalesLine1.SETRANGE(Type, lRecSalesLine1.Type::Item);
                    lRecSalesLine1.SETFILTER("No.", lRecSalesInvoiceLine."No.");
                    if lRecSalesLine1.IsEmpty then begin
                        lRecSalesLine.VALIDATE("Document Type", pRecSalesHeader."Document Type");
                        lRecSalesLine.VALIDATE("Document No.", pRecSalesHeader."No.");
                        lIntLineNo += 10000;
                        lRecSalesLine.VALIDATE("Line No.", lIntLineNo);
                        lRecSalesLine.VALIDATE("Sell-to Customer No.", pRecSalesHeader."Sell-to Customer No.");
                        lRecSalesLine.VALIDATE(Type, lRecSalesLine.Type::Item);
                        lRecSalesLine.VALIDATE("No.", lRecSalesInvoiceLine."No.");
                        lRecSalesLine.INSERT();
                    end;
                end;
            until lRecSalesInvoiceLine.NEXT() = 0;
    end;

    procedure gFncFillCustStock(pRecSalesHeader: Record "Sales Header")
    var
        lRecSalesLine: Record "Sales Line";
        lRecCustStock: Record "Cust. Stock";
    begin

        // COFF-1.ns
        lRecSalesLine.SETRANGE("Document Type", pRecSalesHeader."Document Type");

        lRecSalesLine.SETFILTER("Document No.", pRecSalesHeader."No.");
        lRecSalesLine.SETRANGE(Type, lRecSalesLine.Type::Item);
        lRecSalesLine.SETRANGE("Store stock", true);
        if not lRecSalesLine.FindSet() then exit;
        repeat
            lRecCustStock.VALIDATE("Cust. No.", pRecSalesHeader."Sell-to Customer No.");
            lRecCustStock."Item No." := lRecSalesLine."No.";
            lRecCustStock."Check Date" := WORKDATE();
            lRecCustStock."Quantity in stock" := lRecSalesLine.Stock;
            if not lRecCustStock.INSERT() then;
        until lRecSalesLine.NEXT() = 0;
        // COFF-1.ne
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterModifyEvent', '', false, false)]
    local procedure SalesLineOnAfterModifyEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin

        // lFncSalesLineDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterInsertEvent', '', false, false)]
    local procedure SalesLineOnAfterInsertEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin

        // lFncSalesLineDiscount(Rec);
    end;

    procedure gFncSalesLineDiscount(pRecSalesLine: Record "Sales Line"): Decimal
    var
        lRecItem: Record Item;
        lRecServiceContractHeader: Record "Service Contract Header";
        lRecInventoryPostingGroup: Record "Inventory Posting Group";
    begin
        if (pRecSalesLine."Document Type" = pRecSalesLine."Document Type"::Order) and
            (pRecSalesLine.Type = pRecSalesLine.Type::Item) then begin
            if lRecItem.GET(pRecSalesLine."No.") then
                if not lRecInventoryPostingGroup.GET(lRecItem."Inventory Posting Group") then lRecInventoryPostingGroup.INIT();
            if lRecInventoryPostingGroup."Service Item" then begin
                lRecServiceContractHeader.SETFILTER("Bill-to Customer No.", pRecSalesLine."Bill-to Customer No.");
                lRecServiceContractHeader.SETRANGE(Status, lRecServiceContractHeader.Status::Signed);
                if not lRecServiceContractHeader.IsEmpty() then
                    exit(100);
            end;
        end;
        exit(0);
    end;

    // local procedure lFncTestEnv()
    // var
    //     lRecCustomer: Record Customer;
    //     lRecShiptoAddress: Record "Ship-to Address";
    // begin

    //     lRecCustomer.MODIFYALL("E-Mail", 'heijs@condorsolutions.nl;marc.vanoudheusden@coffee3.nl');
    //     lRecShiptoAddress.MODIFYALL("E-Mail", 'heijs@condorsolutions.nl;marc.vanoudheusden@coffee3.nl');
    // end;

    procedure CS_CustomerCard_MakeNewSalesOrder(var Customer: Record Customer)
    var
        lRecUserSetup: Record 91;
        lRecSalesOrder: Record "Sales Header";
        lRecSalesSetup: Record "Sales & Receivables Setup";
        lCduNoSerMgt: Codeunit NoSeriesManagement;
    begin
        lRecSalesSetup.GET();
        lRecSalesOrder.INIT();
        lRecSalesOrder."No." := '';
        lRecSalesOrder."Document Type" := lRecSalesOrder."Document Type"::Order;
        if lRecSalesOrder."No." = '' then begin
            lRecSalesSetup.TESTFIELD(lRecSalesSetup."Order Nos.");
            lCduNoSerMgt.InitSeries(lRecSalesSetup."Order Nos.", lRecSalesSetup."Order Nos.", TODAY, lRecSalesOrder."No.", lRecSalesSetup."Order Nos.");
        end;

        lRecSalesOrder.InitRecord();
        lRecSalesOrder."Sell-to Customer No." := Customer."No.";
        lRecSalesOrder.VALIDATE(lRecSalesOrder."Sell-to Customer No.");
        lRecSalesOrder.INSERT();

        lRecUserSetup.RESET();
        lRecUserSetup.SETRANGE(lRecUserSetup."User ID", USERID);
        if lRecUserSetup.FindFirst() then
            if lRecUserSetup."Rayon (in verkoopfactuur)" <> 0 then begin
                lRecSalesOrder.Rayon := lRecUserSetup."Rayon (in verkoopfactuur)";
                lRecSalesOrder.Routenummer := 0;
            end;
        lRecSalesOrder.VALIDATE("Location Code", '40');
        lRecSalesOrder.MODIFY();
        PAGE.RUN(PAGE::"Sales Order", lRecSalesOrder);
    end;


    procedure CS_CustomerCard_MakeNewSalesInvoice(var Customer: Record Customer)
    var
        lRecUserSetup: Record 91;
        lRecSalesInv: Record "Sales Header";
        lRecSalesSetup: Record "Sales & Receivables Setup";
        lCduNoSerMgt: Codeunit NoSeriesManagement;
    begin
        lRecSalesSetup.GET();

        lRecSalesInv.INIT();
        lRecSalesInv."No." := '';
        lRecSalesInv."Document Type" := lRecSalesInv."Document Type"::Invoice;
        if lRecSalesInv."No." = '' then begin
            lRecSalesSetup.TESTFIELD("Invoice Nos.");
            lRecSalesSetup.TESTFIELD("Posted Invoice Nos.");
            lCduNoSerMgt.InitSeries(lRecSalesSetup."Invoice Nos.", lRecSalesSetup."Invoice Nos.", TODAY, lRecSalesInv."No.", lRecSalesSetup."Invoice Nos.");
        end;

        lRecSalesInv.InitRecord();
        lRecSalesInv."Sell-to Customer No." := Customer."No.";
        lRecSalesInv.VALIDATE(lRecSalesInv."Sell-to Customer No.");
        lRecSalesInv."No. Series" := PostInvTxt;
        lRecSalesInv."Posting No. Series" := PostInvTxt;
        lRecSalesInv."Shipping No. Series" := ShipmentTxt;
        lRecSalesInv.INSERT();

        lRecUserSetup.RESET();
        lRecUserSetup.SETRANGE(lRecUserSetup."User ID", USERID);
        if lRecUserSetup.FindFirst() then
            if lRecUserSetup."Rayon (in verkoopfactuur)" <> 0 then begin
                lRecSalesInv.Rayon := lRecUserSetup."Rayon (in verkoopfactuur)";
                lRecSalesInv.Routenummer := 0;
            end;
        lRecSalesInv.VALIDATE("Location Code", '40');
        lRecSalesInv.MODIFY();
        PAGE.RUN(PAGE::"Sales Invoice", lRecSalesInv);
    end;

    procedure CS_MyCustomers_Verkoorder(var Rec: Record "My Customer")
    var
        lRecSalespersonPurchaser: Record "Salesperson/Purchaser";
        lRecUser: Record User;
        lRecSalesHeader: Record "Sales Header";
        lCduCondor: Codeunit Condor;
        lPgeDPSalesOrder: Page "DP Sales Order";
    begin
        lRecUser.SETFILTER("User Name", USERID);
        lRecUser.FINDFIRST();
        lRecSalespersonPurchaser.SETFILTER("E-Mail", lRecUser."Contact Email");
        lRecSalespersonPurchaser.FINDFIRST();
        lRecSalespersonPurchaser.TESTFIELD("No. Series");
        lRecSalesHeader."Document Type" := lRecSalesHeader."Document Type"::Order;
        lRecSalesHeader.VALIDATE("No. Series", lRecSalespersonPurchaser."No. Series");
        lRecSalesHeader.SalesPersonOrder := true;
        lRecSalesHeader."Salesperson Code" := lRecSalespersonPurchaser.Code;
        lRecSalesHeader.INSERT(true);

        lRecSalesHeader.VALIDATE("Sell-to Customer No.", Rec."Customer No.");
        lRecSalesHeader.SalesPersonOrder := true;
        lRecSalesHeader.VALIDATE("Posting No. Series", lRecSalesHeader."No. Series");
        lRecSalesHeader.VALIDATE("Posting No.", lRecSalesHeader."No.");

        lRecSalesHeader.Rayon := Rec.Rayon;
        lRecSalesHeader.Routenummer := Rec.Routenummer;

        if Rec.Rayon < 10 then
            lRecSalesHeader.VALIDATE("Location Code", '0' + FORMAT(Rec.Rayon))
        else
            lRecSalesHeader.VALIDATE("Location Code", FORMAT(Rec.Rayon));
        lRecSalesHeader.MODIFY(true);
        COMMIT();
        lRecSalesHeader.SETRANGE("Document Type", lRecSalesHeader."Document Type"::Order);
        lRecSalesHeader.SETFILTER("No.", lRecSalesHeader."No.");
        lRecSalesHeader.FINDFIRST();

        // Maak salesline
        lCduCondor.gFncFillSalesLine(lRecSalesHeader);
        COMMIT();

        lPgeDPSalesOrder.SETRECORD(lRecSalesHeader);
        lPgeDPSalesOrder.RUN();
    end;

    var
        PostInvTxt: Label 'POST-INV';
        //PostInvpTxt: Label 'POST-INVP';
        ShipmentTxt: Label 'SHIPMENTS';


}

