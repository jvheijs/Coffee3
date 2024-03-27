page 50009 "Toolbox John"
{
    ApplicationArea = All;
    Caption = 'Toolbox John';
    PageType = List;
    UsageCategory = Lists;
    Permissions = tabledata 112 = RIMD,
                  tabledata 110 = RIMD;
    // Test John

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
                trigger OnAction()
                var
                    lRecSalesInvHeader: record "Sales invoice Header";
                    lRecSalesShipHeader: record "Sales Shipment Header";

                begin
                    error('JvH');
                    lRecSalesShipHeader.reset;
                    lRecSalesShipHeader.SetRange("No. Printed", 0);
                    if lRecSalesShipHeader.FindFirst() then
                        lRecSalesShipHeader.ModifyAll("No. Printed", 1);
                    Message('Uitgevoerd 22-02-2024');
                end;
            }
        }
    }
}
