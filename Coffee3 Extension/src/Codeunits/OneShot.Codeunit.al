codeunit 50005 "OneShot"
{
    Permissions = TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Return Receipt Header" = rimd;

    trigger OnRun()
    begin

        lFncFillRouteAndRayon();

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
        if SalesShipmentHeader.FINDFIRST() then
            repeat
                if SalesShipmentHeader.Rayon = 0 then
                    if Customer.GET(SalesShipmentHeader."Sell-to Customer No.") then begin
                        SalesShipmentHeader.Rayon := Customer.Rayon;
                        SalesShipmentHeader.Routenummer := Customer.Routenummer;
                        SalesShipmentHeader.MODIFY();
                    end;
            until SalesShipmentHeader.NEXT() = 0;

        SalesInvoiceHeader.MODIFYALL(Rayon, 0);
        SalesInvoiceHeader.MODIFYALL(Routenummer, 0);
        if SalesInvoiceHeader.FINDFIRST() then
            repeat
                if SalesInvoiceHeader.Rayon = 0 then
                    if Customer.GET(SalesInvoiceHeader."Sell-to Customer No.") then begin
                        SalesInvoiceHeader.Rayon := Customer.Rayon;
                        SalesInvoiceHeader.Routenummer := Customer.Routenummer;
                        SalesInvoiceHeader.MODIFY();
                    end;
            until SalesInvoiceHeader.NEXT() = 0;

        SalesCrMemoHeader.MODIFYALL(Rayon, 0);
        SalesCrMemoHeader.MODIFYALL(Routenummer, 0);
        if SalesCrMemoHeader.FINDFIRST() then
            repeat
                if SalesCrMemoHeader.Rayon = 0 then
                    if Customer.GET(SalesCrMemoHeader."Sell-to Customer No.") then begin
                        SalesCrMemoHeader.Rayon := Customer.Rayon;
                        SalesCrMemoHeader.Routenummer := Customer.Routenummer;
                        SalesCrMemoHeader.MODIFY();
                    end;
            until SalesCrMemoHeader.NEXT() = 0;

        ReturnReceiptHeader.MODIFYALL(Rayon, 0);
        ReturnReceiptHeader.MODIFYALL(Routenummer, 0);
        if ReturnReceiptHeader.FINDFIRST() then
            repeat
                if ReturnReceiptHeader.Rayon = 0 then
                    if Customer.GET(ReturnReceiptHeader."Sell-to Customer No.") then begin
                        ReturnReceiptHeader.Rayon := Customer.Rayon;
                        ReturnReceiptHeader.Routenummer := Customer.Routenummer;
                        ReturnReceiptHeader.MODIFY();
                    end;
            until ReturnReceiptHeader.NEXT() = 0;
    end;
}

