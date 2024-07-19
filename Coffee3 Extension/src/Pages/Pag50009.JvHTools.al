page 50009 "Toolbox John"
{
    ApplicationArea = All;
    Caption = 'Toolbox John';
    PageType = List;
    UsageCategory = Lists;
    Permissions = tabledata 112 = RIMD,
                  tabledata 110 = RIMD;

    layout
    {
        area(content)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action("DB instellen als testomgeving")
            {

                Image = Process;
                trigger OnAction()
                var
                    lRecShiptoAddress: Record "Ship-to Address";
                    lRecCustomer: Record Customer;
                    lRecContact: record Contact;
                begin
                    error('Pas op met gebruiken');
                    lRecCustomer.MODIFYALL("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecShiptoAddress.MODIFYALL("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecContact.ModifyAll("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecContact.ModifyAll("Search E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lreccontact.ModifyAll("E-Mail 2", 'Marc.vanOudheusden@coffee3.nl');
                    Message('Alle afleveradressen/klanten omgezet.');
                end;
            }
            action("Eenmalig handtekeningen omzetten")
            {

                Image = Process;
                trigger OnAction()
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
                        until SalesShipmentHeader.next() = 0;


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
                        until SalesInvoiceHeader.next() = 0;
                end;

            }
            action("Alle facturen/verzendingen als afgedrukt")
            {
                ToolTip = 'Alle facturen/verzendingen op afgedrukt 0 zetten i.v.m. mailen';
                Image = Process;
                trigger OnAction()

                var
                    SalesHeaderPrint: record "Sales invoice Header";
                    SalesShipHeaderPrint: Record "Sales Shipment Header";
                begin
                    if confirm('Alle facturen/verzendingen als geprint zetten', false) then begin
                        SalesHeaderPrint.Reset();
                        SalesHeaderPrint.SetRange("No. Printed", 0);
                        SalesHeaderPrint.SetRange(SalesPersonOrder, true);
                        if SalesHeaderPrint.FindFirst() then
                            SalesHeaderPrint.ModifyAll("No. Printed", 1);

                        SalesShipHeaderPrint.reset();
                        SalesShipHeaderPrint.SetRange("No. Printed", 0);
                        if SalesShipHeaderPrint.FindFirst() then
                            SalesShipHeaderPrint.ModifyAll("No. Printed", 1);

                        Message('Alle verkoopfacturen op geprint gezet');
                    end;

                end;
            }

        }
    }
}
