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
        lRecSalesInvoiceHeader.SETRANGE(SalesPersonOrder, TRUE);
        IF lRecSalesInvoiceHeader.FINDFIRST THEN
            REPEAT
                IF (lRecSalesInvoiceHeader."No. Printed" = 0) AND (lRecSalesInvoiceHeader."Source Code" <> 'WISSEN') THEN BEGIN // WISSEN = verwijderd boekstuk JvH
                    lRecSalesInvoiceHeader1.SETRANGE("No.", lRecSalesInvoiceHeader."No.");
                    IF lRecSalesInvoiceHeader1.FINDFIRST THEN;
                    lRecSalesInvoiceHeader1.EmailRecords(FALSE);
                END;
            UNTIL lRecSalesInvoiceHeader.NEXT = 0;

        IF lRecSalesShipmentHeader.FINDFIRST THEN
            REPEAT
                IF lRecCustomer.GET(lRecSalesShipmentHeader."Sell-to Customer No.") THEN BEGIN
                    IF (lRecSalesShipmentHeader."No. Printed" = 0) AND (lRecCustomer."Combine Shipments") THEN BEGIN
                        lRecSalesShipmentHeader1.SETRANGE("No.", lRecSalesShipmentHeader."No.");
                        IF lRecSalesShipmentHeader1.FINDFIRST THEN
                            lRecSalesShipmentHeader1.EmailRecords(FALSE);
                    END;
                END;
            UNTIL lRecSalesShipmentHeader.NEXT = 0;
    end;
}

