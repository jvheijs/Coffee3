pageextension 50012 "CS User Setup" extends "User Setup"
{

    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Rayon (in verkoopfactuur)"; Rec."Rayon (in verkoopfactuur)")
            {
                ApplicationArea = All;
            }
        }

        addafter("Rayon (in verkoopfactuur)")
        {
            field("CS Has Wshe. Employee"; Rec."CS Has Wshe. Employee")
            {
                ApplicationArea = All;
                ToolTip = 'Shows if user has warehouse employees setup.';
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(UserLocation)
            {
                ApplicationArea = All;
                Caption = 'User Location';
                ToolTip = 'View and edit User Location(s)';
                Image = User;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = page "Warehouse Employees";
                RunPageLink = "User ID" = field("User ID");
                RunPageMode = Create;

            }
        }

    }
}
