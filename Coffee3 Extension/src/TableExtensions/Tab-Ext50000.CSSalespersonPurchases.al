tableextension 50000 "CS Salesperson/Purchases" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Rayonfilter"; Code[20])
        {
            Caption = 'Rayonfilter';
            DataClassification = ToBeClassified;
        }
        field(50001; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            Description = 'COFF-1';
        }
    }
}
