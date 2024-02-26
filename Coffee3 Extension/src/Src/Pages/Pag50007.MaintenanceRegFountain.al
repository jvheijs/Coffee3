page 50007 "Maintenance Reg. Fountain"
{
    // CS1.0 080318 JHE : Created.

    Caption = 'Maintenance Registration Fountain';
    DelayedInsert = true;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Maintenance Reg. Machinery";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Fountain)
            {
                Caption = 'Fountain';
                field("Code"; Rec.Code)
                {
                }
                field(Klantnummer; Rec.Klantnummer)
                {
                }
                field(Klantnaam; Rec.Klantnaam)
                {
                }
                field("Type apparaat"; Rec."Type apparaat")
                {
                }
                field(Serienummer; Rec.Serienummer)
                {
                }
                field(Opvoerdatum; Rec.Opvoerdatum)
                {
                }
                field(Actief; Rec.Actief)
                {
                }
            }
            part(Control1000000009; "Maintenance Registration Lines")
            {
                SubPageLink = Klantnummer = FIELD(Klantnummer),
                              "Onderhoudsregistratie code" = FIELD(Code);
            }
        }
    }

    actions
    {
    }
}

