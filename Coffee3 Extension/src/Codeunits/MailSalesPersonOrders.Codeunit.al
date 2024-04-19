codeunit 50001 "MailSalesPersonOrders"
{

    trigger OnRun()
    var
        lRecSalesInvoiceHeader: Record "Sales Invoice Header";
        lRecSalesInvoiceHeader1: Record "Sales Invoice Header";
        lRecSalesShipmentHeader: Record "Sales Shipment Header";
        lRecSalesShipmentHeader1: Record "Sales Shipment Header";
        lRecCustomer: Record Customer;
    begin
        //if (UserId <> 'COFFEE3\MARC.VANOUDHEUSDEN') then
        //    error('Gebruiker is %1, maar moet door Marc van Oudheusden gestart worden i.v.m. Office e-mailaccount.', UserId); // JvH-231023
        lRecSalesInvoiceHeader.SETRANGE(SalesPersonOrder, true);
        if lRecSalesInvoiceHeader.FindSet() then
            repeat
                if (lRecSalesInvoiceHeader."No. Printed" = 0) and (lRecSalesInvoiceHeader."Source Code" <> 'WISSEN') then begin // WISSEN = verwijderd boekstuk JvH
                    lRecSalesInvoiceHeader1.SETRANGE("No.", lRecSalesInvoiceHeader."No.");
                    if lRecSalesInvoiceHeader1.FINDFIRST() then;
                    lRecSalesInvoiceHeader1.EmailRecords(false);
                end;
            until lRecSalesInvoiceHeader.NEXT() = 0;

        if lRecSalesShipmentHeader.FindSet() then
            repeat
                if lRecCustomer.GET(lRecSalesShipmentHeader."Sell-to Customer No.") then
                    if (lRecSalesShipmentHeader."No. Printed" = 0) and (lRecCustomer."Combine Shipments") then begin
                        lRecSalesShipmentHeader1.SETRANGE("No.", lRecSalesShipmentHeader."No.");
                        if lRecSalesShipmentHeader1.FINDFIRST() then
                            lRecSalesShipmentHeader1.EmailRecords(false);
                    end;
            until lRecSalesShipmentHeader.NEXT() = 0;
    end;
}

