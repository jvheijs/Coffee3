codeunit 50003 "CSEventSubscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeServiceCrMemoShipTo', '', false, false)]
    local procedure OnBeforeServiceCrMemoShipTo(var AddrArray: array[8] of Text[100]; CustAddr: array[8] of Text[100]; var ServiceCrMemoHeader: Record "Service Cr.Memo Header"; var IsHandled: Boolean; var Result: Boolean);
    var
        ShipToAddr: Record "Ship-to Address";
    begin
        if ServiceCrMemoHeader."Ship-to Code" <> '' then
            if ShipToAddr.Get(ServiceCrMemoHeader."Customer No.", ServiceCrMemoHeader."Ship-to Code") then begin
                ServiceCrMemoHeader."Ship-to Name" := ShipToAddr.Name;
                ServiceCrMemoHeader."Ship-to Name 2" := ShipToAddr."Name 2";
                ServiceCrMemoHeader."Ship-to Address" := ShipToAddr.Address;
                ServiceCrMemoHeader."Ship-to Address 2" := ShipToAddr."Address 2";
                ServiceCrMemoHeader.Validate("Ship-to Country/Region Code", ShipToAddr."Country/Region Code");
                ServiceCrMemoHeader."Ship-to City" := ShipToAddr.City;
                ServiceCrMemoHeader."Ship-to Post Code" := ShipToAddr."Post Code";
                ServiceCrMemoHeader."Ship-to County" := ShipToAddr.County;
                ServiceCrMemoHeader."Ship-to Contact" := ShipToAddr.Contact;
                ServiceCrMemoHeader."Ship-to Phone" := ShipToAddr."Phone No.";
                ServiceCrMemoHeader."Ship-to Fax No." := ShipToAddr."Fax No.";
                ServiceCrMemoHeader."Ship-to E-Mail" := ShipToAddr."E-Mail";
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeSalesCrMemoShipTo', '', false, false)]
    local procedure OnBeforeSalesCrMemoShipTo(var AddrArray: array[8] of Text[100]; var CustAddr: array[8] of Text[100]; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var Handled: Boolean; var Result: Boolean);
    var
        ShipToAddr: Record "Ship-to Address";
    begin
        if SalesCrMemoHeader."Ship-to Code" <> '' then
            if ShipToAddr.Get(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code") then begin
                SalesCrMemoHeader."Ship-to Name" := ShipToAddr.Name;
                SalesCrMemoHeader."Ship-to Name 2" := ShipToAddr."Name 2";
                SalesCrMemoHeader."Ship-to Address" := ShipToAddr.Address;
                SalesCrMemoHeader."Ship-to Address 2" := ShipToAddr."Address 2";
                SalesCrMemoHeader.Validate("Ship-to Country/Region Code", ShipToAddr."Country/Region Code");
                SalesCrMemoHeader."Ship-to City" := ShipToAddr.City;
                SalesCrMemoHeader."Ship-to Post Code" := ShipToAddr."Post Code";
                SalesCrMemoHeader."Ship-to County" := ShipToAddr.County;
                SalesCrMemoHeader."Ship-to Contact" := ShipToAddr.Contact;
            end;
    end;


    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeOnDelete', '', false, false)]
    local procedure CS_Item_OnBeforeOnDelete(var Item: Record Item; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterOnInsert', '', false, false)]
    local procedure CS_SalesHeader_OnAfterOnInsert(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then
            SalesHeader."Posting No." := SalesHeader."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean);
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if SalesHeader."Combine Shipments" then begin
                SalesHeader.Ship := true;
                SalesHeader.Invoice := false;
                HideDialog := true;
            end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure CS_SalesHeader_OnAfterValidate_SellToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        ShipToRecL: Record "Ship-to Address";
        lRecUserSetup: Record "User Setup";
        Cust: Record Customer;
    begin
        if not Rec.imported and not Rec.SalesPersonOrder and not Rec."Combine Shipments" then
            if CONFIRM(Text50005) then
                Rec.Afhalen := true
            else begin
                Rec.Afhalen := false;
                Cust.GET(Rec."Sell-to Customer No.");
                if (Cust."Payment Method Code" = '01') then
                    if CONFIRM(Text50006) then begin
                        Rec.VALIDATE("Payment Method Code", '05');
                        Rec.VALIDATE("Payment Terms Code", '05');
                    end else
                        Rec.VALIDATE("Payment Method Code", Cust."Payment Method Code");
            end;

        if lRecUserSetup.GET(UserId) then
            if (lRecUserSetup."Rayon (in verkoopfactuur)" <> 0) then begin
                Rec.Rayon := lRecUserSetup."Rayon (in verkoopfactuur)";
                Rec.Routenummer := 0;
            end;

        if ShipToRecL.GET(Rec."Sell-to Customer No.", 'BEZOEK') then
            Rec.VALIDATE("Ship-to Code", 'BEZOEK');
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure CS_SalesHeader_OnAfterValidate_No(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec.SalesPersonOrder and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            Rec.VALIDATE("No. Series", 'VFRAYON2');
            Rec.VALIDATE("Posting No. Series", 'VFRAYON2');
            Rec."Posting No." := Rec."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure CS_SalesHeader_OnAfterValidate_LocationCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec."Document Type" in [Rec."Document Type"::Order, Rec."Document Type"::"Return Order"] then
            if (Rec."Location Code" = '40') then
                Rec."Posting No." := ''
            else
                Rec."Posting No." := Rec."No.";
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInitRecord', '', false, false)]
    local procedure CS_SalesHeader_OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."CS Posting Date" := SalesHeader."Posting Date";
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure CS_SalesHeader_OnAfterValidate_PostingDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        SalesHeader."CS Posting Date" := SalesHeader."Posting Date";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure CS_SalesLine_OnAfterValidate_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        lRecSalesInvoiceLine: Record "Sales Invoice Line";
        lRecCustStock: Record "Cust. Stock";
    begin
        Rec.GetSalesHeader(SalesHeader, Currency);

        if SalesHeader.SalesPersonOrder and
           (Rec."Document Type" = Rec."Document Type"::Order) then begin
            // Laatste bestelling
            lRecSalesInvoiceLine.SETCURRENTKEY("Sell-to Customer No.", "Shipment Date");
            lRecSalesInvoiceLine.SETRANGE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lRecSalesInvoiceLine.SETRANGE(Type, lRecSalesInvoiceLine.Type::Item);
            lRecSalesInvoiceLine.SETFILTER("No.", Rec."No.");
            lRecSalesInvoiceLine.SETFILTER(Quantity, '<>0');
            Rec.LastOrder := 0;
            Rec."LastOrder-1" := 0;
            Rec."LastOrder-2" := 0;
            Rec.DateLastOrder := 0D;
            Rec."DateLastOrder-1" := 0D;
            Rec."DateLastOrder-2" := 0D;
            Rec."Stock-0" := 0;
            Rec."Stock-1" := 0;
            Rec."Stock-2" := 0;
            Rec."DateStock-0" := 0D;
            Rec."DateStock-1" := 0D;
            Rec."DateStock-2" := 0D;

            if lRecSalesInvoiceLine.FINDLAST() then begin
                Rec.LastOrder := lRecSalesInvoiceLine.Quantity;
                Rec.DateLastOrder := lRecSalesInvoiceLine."Shipment Date";
                if lRecSalesInvoiceLine.NEXT(-1) <> 0 then begin
                    Rec."LastOrder-1" := lRecSalesInvoiceLine.Quantity;
                    Rec."DateLastOrder-1" := lRecSalesInvoiceLine."Shipment Date";
                end;
                if lRecSalesInvoiceLine.NEXT(-1) <> 0 then begin
                    Rec."LastOrder-2" := lRecSalesInvoiceLine.Quantity;
                    Rec."DateLastOrder-2" := lRecSalesInvoiceLine."Shipment Date";
                end;
            end;

            lRecCustStock.SETFILTER("Cust. No.", rec."Sell-to Customer No.");
            lRecCustStock.SETFILTER("Item No.", rec."No.");
            if lRecCustStock.FINDLAST() then begin
                rec."Stock-0" := lRecCustStock."Quantity in stock";
                rec."DateStock-0" := lRecCustStock."Check Date";
            end;
            if lRecCustStock.NEXT(-1) <> 0 then begin
                rec."Stock-1" := lRecCustStock."Quantity in stock";
                rec."DateStock-1" := lRecCustStock."Check Date";
            end;
            if lRecCustStock.NEXT(-1) <> 0 then begin
                rec."Stock-2" := lRecCustStock."Quantity in stock";
                rec."DateStock-2" := lRecCustStock."Check Date";
            end;

        end;
        Rec."Line Discount %" := gCduCondor.gFncSalesLineDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateShipmentDate', '', false, false)]
    local procedure CS_SalesLine_OnBeforeValidateShipmentDate(sender: Record "Sales Line"; var IsHandled: Boolean)
    begin
        sender.GetSalesHeader(SalesHeader, Currency);
        if SalesHeader."Tijd terminal" <> 0T then
            sender.SetHasBeenShown();
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure CS_SalesLine_OnAfterValidate_Quantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec."Line Discount %" := gCduCondor.gFncSalesLineDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 5900, 'OnAfterValidateEvent', 'Customer No.', false, false)]
    local procedure CS_ServiceHeader_OnafterValidate_CustomerNo(var Rec: Record "Service Header"; var xRec: Record "Service Header"; CurrFieldNo: Integer)
    var
        ShipToRecL: Record "Ship-to Address";
    begin
        if ShipToRecL.GET(Rec."Customer No.", 'BEZOEK') then
            Rec.VALIDATE("Ship-to Code", ShipToRecL.Code);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure CS_SalesPost_OnRunOnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header")
    begin
        gCduCondor.gFncFillCustStock(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CS_SalesPost_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        RemboursRec: Record "Reimbursement Label";
        CustomerRec: Record Customer;
    begin
        //  Remboursbestand vullen
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then begin
            if (SalesHeader."Payment Method Code" in ['05']) then begin
                if (SalesHeader.Afhalen = false) then begin
                    RemboursRec.INIT();
                    if SalesInvHdrNo <> '' then
                        RemboursRec.Code := SalesInvHdrNo
                    else
                        RemboursRec.Code := SalesShptHdrNo;

                    RemboursRec.Klantnr := SalesHeader."Sell-to Customer No.";
                    RemboursRec.Naam := SalesHeader."Sell-to Customer Name";
                    RemboursRec.Adres := SalesHeader."Ship-to Address";
                    RemboursRec.Postcode := SalesHeader."Ship-to Post Code";
                    RemboursRec.Plaats := SalesHeader."Ship-to City";
                    CustLedgerEntry.CALCFIELDS(CustLedgerEntry."Amount (LCY)");
                    RemboursRec.Bedrag := CustLedgerEntry."Amount (LCY)";
                    RemboursRec.Bankrekeningnr := SalesHeader."Bank Account Code";
                    RemboursRec.Afgedrukt := false;
                    RemboursRec.Aflevernaam := SalesHeader."Ship-to Name";
                    RemboursRec."Afl.contactpersoon" := SalesHeader."Ship-to Contact";
                    RemboursRec.Afleverland := SalesHeader."Bill-to Country/Region Code";
                    if RemboursRec.Afleverland = '' then RemboursRec.Afleverland := 'NL';
                    RemboursRec."Aantal colli" := SalesHeader."Aantal colli";
                    RemboursRec.PTTEtiketGeprint := false;
                    RemboursRec.Locatie := SalesHeader."Location Code";
                    RemboursRec.Betalingswijze := SalesHeader."Payment Method Code";
                    RemboursRec.Leveringswijze := '2';
                    if RemboursRec.Klantnr <> '' then begin
                        if CustomerRec.get(RemboursRec.Klantnr) then
                            RemboursRec.Email := CustomerRec."E-Mail"
                        else
                            RemboursRec.Email := '';
                    end;
                    RemboursRec.INSERT();
                end;
            end;
            if (SalesHeader."Payment Method Code" in ['02', '03', '04']) and
                (SalesHeader."Location Code" = '40') and (SalesHeader.Afhalen = false)
            then begin
                RemboursRec.INIT();
                if SalesInvHdrNo <> '' then
                    RemboursRec.Code := SalesInvHdrNo
                else
                    RemboursRec.Code := SalesShptHdrNo;
                RemboursRec.Klantnr := SalesHeader."Sell-to Customer No.";
                RemboursRec.Naam := SalesHeader."Ship-to Name";
                RemboursRec.Adres := SalesHeader."Ship-to Address";
                RemboursRec.Postcode := SalesHeader."Ship-to Post Code";
                RemboursRec.Plaats := SalesHeader."Ship-to City";
                CustLedgerEntry.CALCFIELDS(CustLedgerEntry."Amount (LCY)");
                RemboursRec.Bedrag := CustLedgerEntry."Amount (LCY)";
                RemboursRec.Bankrekeningnr := SalesHeader."Bank Account Code";
                RemboursRec.Afgedrukt := true;
                RemboursRec.Aflevernaam := SalesHeader."Ship-to Name";
                RemboursRec."Afl.contactpersoon" := SalesHeader."Ship-to Contact";
                RemboursRec.Afleverland := SalesHeader."Bill-to Country/Region Code";
                if RemboursRec.Afleverland = '' then RemboursRec.Afleverland := 'NL';
                RemboursRec."Aantal colli" := SalesHeader."Aantal colli";
                RemboursRec.PTTEtiketGeprint := false;
                RemboursRec.Locatie := SalesHeader."Location Code";
                RemboursRec.Betalingswijze := SalesHeader."Payment Method Code";
                RemboursRec.Leveringswijze := '1';
                if RemboursRec.Klantnr <> '' then begin
                    if CustomerRec.get(RemboursRec.Klantnr) then
                        RemboursRec.Email := CustomerRec."E-Mail"
                    else
                        RemboursRec.Email := '';
                end;
                RemboursRec.INSERT();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure CS_SalesPost_OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesInvHeader."CS Shipment Date" := SalesInvHeader."Shipment Date";
        SalesInvHeader."CS Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
        SalesHeader.calcfields("Signature");
        if SalesHeader."Signature".HasValue then
            SalesInvHeader."Signature" := SalesHeader."Signature";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure CS_SalesPost_OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header");
    begin
        SalesHeader.calcfields("Signature");
        if SalesHeader."Signature".HasValue then
            SalesShptHeader."Signature" := SalesHeader."Signature";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure CS_SalesShipmentLine_OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line");
    begin
        SalesLine.Description := SalesLine.Description + ' ' + Format(SalesShptLine."Posting Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine, '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header");
    begin
        SalesLine.Description := SalesLine.Description + ' ' + Format(SalesShptLine."Posting Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterDescriptionSalesLineInsert', '', false, false)]
    local procedure CS_SalesShipmentLine_OnAfterDescriptionSalesLineInsert(var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line"; var NextLineNo: Integer);
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        NextLineNo := NextLineNo + 10000;
        SalesLine.init();
        SalesLine."Line No." := NextLineNo;
        SalesShipmentHeader.get(SalesShipmentLine."Document No.");
        SalesLine.Description := SalesShipmentHeader."Sell-to Customer Name";
        SalesLine.Insert(false);
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnValidateItemNoOnAfterGetDefaultBin', '', false, false)]
    local procedure CS_AssemblyHeader_OnValidateItemNoOnAfterGetDefaultBin(var AssemblyHeader: Record "Assembly Header")
    begin
        AssemblyHeader.SetWarningsOff();
    end;

    var
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        gCduCondor: Codeunit Condor;

        Text50005: Label 'Wordt de bestelling afgehaald?';
        Text50006: Label 'Wilt u de betalingswijze wijzigen van KONTANT naar PTT-REMBOURS voor deze factuur?';

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Document-Mailing", OnBeforeSendEmail, '', false, false)]

    local procedure OnbeforeSendMail(var TempEmailItem: record "Email Item" temporary)
    begin
        //TempEmailItem."Send CC" := '';    
        TempEmailItem."Send BCC" := 'no-reply@coffee3.nl';
    end;
}
