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
            action("Eenmalig code John")
            {

                Image = Process;
                trigger OnAction()
                var
                    RecSalesInvHeader: record "Sales invoice Header";
                    lRecSalesShipHeader: record "Sales Shipment Header";
                begin

                    error('JvH');
                    lRecSalesShipHeader.RESET();
                    lRecSalesShipHeader.SetRange("No. Printed", 0);
                    if lRecSalesShipHeader.FindFirst() then
                        lRecSalesShipHeader.ModifyAll("No. Printed", 1);
                    Message('Uitgevoerd 22-02-2024');
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
                    error('Pas op met gebruiken');
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
            }

        }
    }
}
