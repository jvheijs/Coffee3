page 50001 "Areas and Customerstatusses"
{
    PageType = List;
    SourceTable = "Area and Customerstatus";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Rayoncode; Rec.Rayoncode)
                {
                }
                field("Omschrijving rayon"; Rec."Omschrijving rayon")
                {
                }
            }
        }
    }

    actions
    {
    }
}

