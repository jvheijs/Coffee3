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
                Image = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    if Rec.FINDFIRST() then
                        repeat
                            SalesInvHeader.RESET();
                            SalesInvHeader.SETRANGE(SalesInvHeader."No.", Rec."No.");
                            SalesInvHeader.SETFILTER(Verzendprofiel, '%1|%2', '1 ALLEEN E-MAIL', '3 PRINT EN EMAIL');
                            if SalesInvHeader.FINDFIRST() then;
                            SalesInvHeader.EmailRecords(false);
                        // COMMIT();  // Tijdelijk uitgeschakeld i.v.m. SQL problemen, misschien hierdoor?
                        until Rec.NEXT() = 0;

                    Rec.RESET();
                    MESSAGE('Uitgevoerd.');
                end;
            }
        }
    }
}
