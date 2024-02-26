pageextension 50006 "CS Vendor Card" extends "Vendor Card"
{
    Description = 'CS1.0';

    layout
    {
        addafter("Our Account No.")
        {
            field("Telefoonnr. contactpersoon"; Rec."Telefoonnr. contactpersoon")
            {
                ApplicationArea = All;
            }
        }
    }
}
