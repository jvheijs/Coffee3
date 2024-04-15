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
                ToolTip = 'Emailadressen enz. aanpassen naar Marc v.O.';
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
                ToolTip = 'Eenmalige acties';
                Image = Process;
                trigger OnAction()
                var
                    recServiceContract: record "Service Contract Header";
                    recCustomer: Record Customer;

                begin
                    recServiceContract.Reset();
                    recServiceContract.SetRange(Status, recServiceContract.Status::Signed);
                    recServiceContract.SetFilter("Payment Method Code", '');
                    if recServiceContract.FindSet() then
                        repeat
                            recCustomer.get(recServiceContract."Customer No.");
                            recServiceContract.Validate(recServiceContract."Payment Method Code", recCustomer."Payment Method Code");
                            recServiceContract.Modify();
                        until recServiceContract.Next() = 0;
                    message('Contracten aangepast');
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
