pageextension 50029 "CS VAT Amount Lines" extends "VAT Amount Lines"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("EBasisbedrag BTW"; Rec."EBasisbedrag BTW")
            {
                ApplicationArea = All;
            }
            field("EBTW-bedrag"; Rec."EBTW-bedrag")
            {
                ApplicationArea = All;
            }
            field("EBedrag incl. BTW"; Rec."EBedrag incl. BTW")
            {
                ApplicationArea = All;
            }
        }
    }
}
