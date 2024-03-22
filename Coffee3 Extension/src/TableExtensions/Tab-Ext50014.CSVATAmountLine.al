tableextension 50014 "CS VAT Amount Line" extends "VAT Amount Line"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; "EBasisbedrag BTW"; Decimal)
        {
            Caption = 'EBasicAmount VAT';
            DataClassification = ToBeClassified;
        }
        field(50001; "EBTW-bedrag"; Decimal)
        {
            Caption = 'EVAT-Amount';
            DataClassification = ToBeClassified;
        }
        field(50002; "EBedrag incl. BTW"; Decimal)
        {
            Caption = 'EAmount incl. VAT';
            DataClassification = ToBeClassified;
        }
    }
}
