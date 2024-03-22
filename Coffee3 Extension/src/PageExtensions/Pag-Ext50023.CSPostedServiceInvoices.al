pageextension 50023 "CS Posted Service Invoices" extends "Posted Service Invoices"
{
    layout
    {
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
            action("Batch Mailen Condor")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    lRecServInvHeader: Record "Service Invoice Header";
                    DocumentSendingProfile: Record "Document Sending Profile";
                    DummyReportSelections: Record "Report Selections";
                    DocumentTypeTxt: Text[50];
                    ReportDistributionMgt: Codeunit "Report Distribution Management";
                    IsHandled: Boolean;
                    ShowDialog: Boolean;
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    IF Rec.FINDFIRST THEN BEGIN
                        REPEAT
                            lRecServInvHeader.RESET;
                            lRecServInvHeader.SETRANGE(lRecServInvHeader."No.", Rec."No.");
                            lRecServInvHeader.SETFILTER(Verzendprofiel, '%1|%2', '1 ALLEEN E-MAIL', '3 PRINT EN EMAIL');
                            IF lRecServInvHeader.FINDFIRST THEN begin
                                // lRecServInvHeader.SendRecords(); // jvh
                                //DocumentTypeTxt := ReportDistributionMgt.GetFullDocumentTypeText(rec);
                                // Oude aanroep functie!!
                                //DocumentSendingProfile.TrySendToEMail(
                                // DummyReportSelections.Usage::"SM.Invoice", Rec, FIELDNO("No."), DocumentTypeTxt, FIELDNO("Bill-to Customer No."), false);

                                //IsHandled := false;
                                //ShowDialog := false;
                                //OnBeforeEmailRecords(DummyReportSelections, Rec, DocumentTypeTxt, ShowDialog, IsHandled);
                                //if not IsHandled then
                                //    DocumentSendingProfile.TrySendToEMail(
                                //    DummyReportSelections.Usage::"SM.Invoice".AsInteger(), rec, FieldNo("No."), DocumentTypeTxt,
                                //    FieldNo("Bill-to Customer No."), false);
                            end;
                        UNTIL Rec.NEXT = 0;
                    END;
                    Rec.RESET;
                    MESSAGE('Uitgevoerd.');
                end;

            }

        }

    }
    [IntegrationEvent(false, false)]
    local procedure OnBeforeEmailRecords(var ReportSelections: Record "Report Selections"; var SalesInvoiceHeader: Record "Service Invoice Header"; DocTxt: Text; ShowDialog: Boolean; var IsHandled: Boolean)
    begin
    end;
}