codeunit 50006 CSCondorInstall
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Signature: Record "CS Signature";
    begin
        if SalesHeader.findset() then
            repeat
                if not Signature.get(Database::"Sales Header", SalesHeader."No.", salesheader."Document Type".asinteger()) then begin
                    SalesHeader.calcfields("Signature");
                    if salesheader.signature.hasvalue then begin
                        Signature.init();
                        Signature."Signature" := SalesHeader."Signature";
                        Signature."Document No." := SalesHeader."No.";
                        Signature."Document Type" := salesheader."Document Type".asinteger();
                        Signature."Table No." := Database::"Sales Header";
                        Signature.Insert(true);
                    end;
                end;
            until SalesHeader.next() = 0;

        if SalesShipmentHeader.findset() then
            repeat
                if not Signature.get(Database::"Sales Shipment Header", SalesShipmentHeader."No.", 0) then begin
                    SalesShipmentHeader.calcfields("Signature");
                    if SalesShipmentHeader.signature.hasvalue then begin
                        Signature.init();
                        Signature."Signature" := SalesShipmentHeader."Signature";
                        Signature."Document No." := SalesShipmentHeader."No.";
                        Signature."Table No." := Database::"Sales Shipment Header";
                        Signature.Insert(true);
                    end
                end;
            until SalesHeader.next() = 0;


        if SalesInvoiceHeader.findset() then
            repeat
                if not Signature.get(Database::"Sales Invoice Header", SalesInvoiceHeader."No.", 0) then begin
                    SalesInvoiceHeader.calcfields("Signature");
                    if SalesInvoiceHeader.signature.hasvalue then begin
                        Signature.init();
                        Signature."Signature" := SalesInvoiceHeader."Signature";
                        Signature."Document No." := SalesInvoiceHeader."No.";
                        Signature."Table No." := Database::"Sales Invoice Header";
                        Signature.Insert(true);
                    end
                end;
            until SalesHeader.next() = 0;

    end;
}
