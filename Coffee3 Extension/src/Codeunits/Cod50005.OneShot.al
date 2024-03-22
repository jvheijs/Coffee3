codeunit 50005 "OneShot"
{
    Permissions = TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Return Receipt Header" = rimd;

    trigger OnRun()
    begin

        lFncFillRouteAndRayon;

        MESSAGE('Gereed');
    end;

    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        Customer: Record Customer;

    local procedure lFncFillRouteAndRayon()
    begin

        SalesShipmentHeader.MODIFYALL(Rayon, 0);
        SalesShipmentHeader.MODIFYALL(Routenummer, 0);
        IF SalesShipmentHeader.FINDFIRST THEN
            REPEAT
                IF SalesShipmentHeader.Rayon = 0 THEN BEGIN
                    IF Customer.GET(SalesShipmentHeader."Sell-to Customer No.") THEN BEGIN
                        SalesShipmentHeader.Rayon := Customer.Rayon;
                        SalesShipmentHeader.Routenummer := Customer.Routenummer;
                        SalesShipmentHeader.MODIFY;
                    END;
                END;
            UNTIL SalesShipmentHeader.NEXT = 0;

        SalesInvoiceHeader.MODIFYALL(Rayon, 0);
        SalesInvoiceHeader.MODIFYALL(Routenummer, 0);
        IF SalesInvoiceHeader.FINDFIRST THEN
            REPEAT
                IF SalesInvoiceHeader.Rayon = 0 THEN BEGIN
                    IF Customer.GET(SalesInvoiceHeader."Sell-to Customer No.") THEN BEGIN
                        SalesInvoiceHeader.Rayon := Customer.Rayon;
                        SalesInvoiceHeader.Routenummer := Customer.Routenummer;
                        SalesInvoiceHeader.MODIFY;
                    END;
                END;
            UNTIL SalesInvoiceHeader.NEXT = 0;

        SalesCrMemoHeader.MODIFYALL(Rayon, 0);
        SalesCrMemoHeader.MODIFYALL(Routenummer, 0);
        IF SalesCrMemoHeader.FINDFIRST THEN
            REPEAT
                IF SalesCrMemoHeader.Rayon = 0 THEN BEGIN
                    IF Customer.GET(SalesCrMemoHeader."Sell-to Customer No.") THEN BEGIN
                        SalesCrMemoHeader.Rayon := Customer.Rayon;
                        SalesCrMemoHeader.Routenummer := Customer.Routenummer;
                        SalesCrMemoHeader.MODIFY;
                    END;
                END;
            UNTIL SalesCrMemoHeader.NEXT = 0;

        ReturnReceiptHeader.MODIFYALL(Rayon, 0);
        ReturnReceiptHeader.MODIFYALL(Routenummer, 0);
        IF ReturnReceiptHeader.FINDFIRST THEN
            REPEAT
                IF ReturnReceiptHeader.Rayon = 0 THEN BEGIN
                    IF Customer.GET(ReturnReceiptHeader."Sell-to Customer No.") THEN BEGIN
                        ReturnReceiptHeader.Rayon := Customer.Rayon;
                        ReturnReceiptHeader.Routenummer := Customer.Routenummer;
                        ReturnReceiptHeader.MODIFY;
                    END;
                END;
            UNTIL ReturnReceiptHeader.NEXT = 0;
    end;
}

