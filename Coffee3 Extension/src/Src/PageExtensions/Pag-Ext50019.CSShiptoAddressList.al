pageextension 50019 "CS Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addfirst(Control1)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
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
    }

    actions
    {
        addafter("Online Map")
        {
            action("Customer Card")
            {
                ApplicationArea = All;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Customer No.");
            }
        }
    }
}
