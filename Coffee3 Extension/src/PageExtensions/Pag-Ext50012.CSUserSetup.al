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
    }
}
