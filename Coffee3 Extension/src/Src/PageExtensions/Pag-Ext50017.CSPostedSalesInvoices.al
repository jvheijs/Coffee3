pageextension 50017 "CS Posted Sales Invoices" extends "Posted Sales Invoices"
{

    layout
    {
        addafter("Remaining Amount")
        {
            field(Rayon; Rec.Rayon)
            {
                ApplicationArea = All;
            }
            field(Routenummer; Rec.Routenummer)
            {
                ApplicationArea = All;
            }
        }
        addafter("Document Exchange Status")
        {
            field(Verzendprofiel; Rec.Verzendprofiel)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addbefore(SendCustom)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    IF Rec.FINDFIRST THEN BEGIN
                        REPEAT
                            SalesInvHeader.RESET;
                            SalesInvHeader.SETRANGE(SalesInvHeader."No.", Rec."No.");
                            SalesInvHeader.SETFILTER(Verzendprofiel, '%1|%2', '1 ALLEEN E-MAIL', '3 PRINT EN EMAIL');
                            IF SalesInvHeader.FINDFIRST THEN;
                            SalesInvHeader.EmailRecords(FALSE);
                        // COMMIT;  // Tijdelijk uitgeschakeld i.v.m. SQL problemen, misschien hierdoor?
                        UNTIL Rec.NEXT = 0;
                    END;
                    Rec.RESET;
                    MESSAGE('Uitgevoerd.');
                end;
            }
        }
    }
}
