pageextension 50026 "CS Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field(Verzendprofiel; Rec.Verzendprofiel)
            {
                ApplicationArea = All;
            }
        }
    }
}
