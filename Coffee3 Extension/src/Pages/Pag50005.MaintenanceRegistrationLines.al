page 50005 "Maintenance Registration Lines"
{
    // CS1.0 080318 JHE : Created.

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Maintenance Registration Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field(Klantnummer; Rec.Klantnummer)
                {
                }
                field(Regelnummer; Rec.Regelnummer)
                {
                }
                field(Datum; Rec.Datum)
                {
                }
                field(Omschrijving; Rec.Omschrijving)
                {
                }
                field("Omschrijving 2"; Rec."Omschrijving 2")
                {
                }
                field(Gebruiker; Rec.Gebruiker)
                {
                }
            }
        }
    }

    actions
    {
    }
}

