page 50003 "Reimbursement Labels"
{
    // CS1.0 060418 JHE : Created.

    PageType = List;
    SourceTable = "Reimbursement Label";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Omschrijving; Rec.Omschrijving)
                {
                }
                field("Opnemen in campagnes"; Rec."Opnemen in campagnes")
                {
                }
                field(Naam; Rec.Naam)
                {
                }
                field(Adres; Rec.Adres)
                {
                }
                field(Plaats; Rec.Plaats)
                {
                }
                field(Bedrag; Rec.Bedrag)
                {
                }
                field(Bankrekeningnr; Rec.Bankrekeningnr)
                {
                }
                field(Afgedrukt; Rec.Afgedrukt)
                {
                }
                field(Klantnr; Rec.Klantnr)
                {
                }
                field(Postcode; Rec.Postcode)
                {
                }
                field(PTTEtiketGeprint; Rec.PTTEtiketGeprint)
                {
                }
                field("Aantal colli"; Rec."Aantal colli")
                {
                }
                field(Aflevernaam; Rec.Aflevernaam)
                {
                }
                field("Afl.contactpersoon"; Rec."Afl.contactpersoon")
                {
                }
                field("Straatnaam afleveradres"; Rec."Straatnaam afleveradres")
                {
                }
                field("Huisnummer afleveradres"; Rec."Huisnummer afleveradres")
                {
                }
                field("Toevoeging afleveradres"; Rec."Toevoeging afleveradres")
                {
                }
                field(Afleverland; Rec.Afleverland)
                {
                }
                field(Locatie; Rec.Locatie)
                {
                }
                field(Betalingswijze; Rec.Betalingswijze)
                {
                }
                field(Leveringswijze; Rec.Leveringswijze)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateSendingFilePTT)
            {
                Caption = 'Sending File PTT';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = ExportFile;

                trigger OnAction()
                var
                    SendingFilePTT: XmlPort "Sending File PTT";
                begin
                    SendingFilePTT.RUN;
                end;

            }
        }
    }
}

