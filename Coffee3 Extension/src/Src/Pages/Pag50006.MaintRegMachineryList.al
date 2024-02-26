page 50006 "Maint. Reg. Machinery List"
{
    // CS1.0 080318 JHE : Created.
    Caption = 'Maintenance Registration Machinery List';
    CardPageID = "Maintenance Reg. Fountain";
    Editable = false;
    PageType = List;
    SourceTable = "Maintenance Reg. Machinery";
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
            }
        }
    }

    actions
    {
    }
}

