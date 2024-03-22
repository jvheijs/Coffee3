page 50000 "Routes"
{
    // CS1.0 160318 JHE : Gecreeerd.

    PageType = List;
    SourceTable = Route;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Regelnummer; Rec.Regelnummer)
                {
                }
                field(Rayonnummer; Rec.Rayonnummer)
                {
                }
                field(Routenummer; Rec.Routenummer)
                {
                }
                field(Dropcode; Rec.Dropcode)
                {
                }
                field(Klantnummer; Rec.Klantnummer)
                {
                }
                field(Klantnaam; Rec.Klantnaam)
                {
                }
                field(Klantadres; Rec.Klantadres)
                {
                }
                field(Klantpostcode; Rec.Klantpostcode)
                {
                }
                field(Klantplaats; Rec.Klantplaats)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ChangeRoutes)
            {
                Caption = 'Routes Verplaatsen';
                image = Change;
                ToolTip = 'Verplaats routes.';
                RunObject = Report "Change Route";
            }

            action(SortRoutes)
            {
                Caption = 'Routes Sorteren';
                image = SortAscending;
                ToolTip = 'Sorteer routes.';
                RunObject = Report "Route Sorting";
            }

        }
    }
}

