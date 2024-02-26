page 50008 "Maintenance Overview"
{
    // CS1.0 080318 JHE : Created.

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Maintenance Reg. Machinery";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field("Type apparaat"; Rec."Type apparaat")
                {
                }
                field("Omschrijving apparaat"; Rec."Omschrijving apparaat")
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
        }
    }

    actions
    {
    }
}

