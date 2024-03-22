page 50021 Daysheet
{
    Caption = 'Dag overzicht';
    PageType = Card;
    SourceTable = Integer;
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(Algemeen)
            {
                Caption = 'Algemeen';
                field(Verkoper; gRecSalespersonPurchaser.Name)
                {
                    ApplicationArea = All;
                }
                field(Datum; gTxtDateFilter)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        lFncRevenue;
                    end;
                }
                field("Aantal klanten"; gIntNoOfCust)
                {
                    ApplicationArea = All;
                }
                field("Omzet excl. BTW"; gDecTotalExVAT)
                {
                    ApplicationArea = All;
                }
                field("Omzet incl. BTW"; gDecTotalIncVAT)
                {
                    ApplicationArea = All;
                }
                field("Contact excl. BTW"; gDecCashExVAT)
                {
                    ApplicationArea = All;
                }
                field("Contact incl. BTW"; gDecCashIncVAT)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        gTxtDateFilter := FORMAT(WORKDATE);
        gRecUser.SETFILTER("User Name", USERID);
        gRecUser.FINDFIRST;
        gRecSalespersonPurchaser.SETFILTER("E-Mail", gRecUser."Contact Email");
        gRecSalespersonPurchaser.FINDFIRST;

        lFncRevenue;
    end;

    local procedure lFncRevenue()
    begin
        gRecSalesInvoiceHeader.SETFILTER(Rayon, gRecSalespersonPurchaser.Rayonfilter);
        gRecSalesInvoiceHeader.SETFILTER("Posting Date", gTxtDateFilter);
        gRecSalesInvoiceHeader.SETRANGE(SalesPersonOrder, TRUE);
        gIntNoOfCust := gRecSalesInvoiceHeader.COUNT;

        gDecCashExVAT := 0;
        gDecCashIncVAT := 0;
        gDecTotalExVAT := 0;
        gDecTotalIncVAT := 0;

        IF gRecSalesInvoiceHeader.FINDFIRST THEN
            REPEAT
                gRecSalesInvoiceHeader.CALCFIELDS(Amount, "Amount Including VAT");
                gDecTotalExVAT := gDecTotalExVAT + gRecSalesInvoiceHeader.Amount;
                gDecTotalIncVAT := gDecTotalIncVAT + gRecSalesInvoiceHeader."Amount Including VAT";
                IF gRecSalesInvoiceHeader."Payment Method Code" = '01' THEN BEGIN
                    gDecCashExVAT := gDecCashExVAT + gRecSalesInvoiceHeader.Amount;
                    gDecCashIncVAT := gDecCashIncVAT + gRecSalesInvoiceHeader."Amount Including VAT";
                END;
            UNTIL gRecSalesInvoiceHeader.NEXT = 0;
    end;


    var
        gTxtDateFilter: Text;
        gDecTotalExVAT: Decimal;
        gDecTotalIncVAT: Decimal;
        gDecCashExVAT: Decimal;
        gDecCashIncVAT: Decimal;
        gIntNoOfCust: Integer;
        gRecSalesInvoiceHeader: Record "Sales Invoice Header";
        gRecSalesInvoiceLine: Record "Sales Invoice Line";
        gRecSalespersonPurchaser: Record "Salesperson/Purchaser";
        gRecUser: Record User;


}
