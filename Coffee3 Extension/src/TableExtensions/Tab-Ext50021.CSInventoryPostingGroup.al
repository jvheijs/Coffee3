tableextension 50021 "CS Inventory Posting Group" extends "Inventory Posting Group"
{
    fields
    {
        field(50000; "Service Item"; Boolean)
        {
            Description = 'COFF-1';
            Caption = 'Service artikel';
            DataClassification = ToBeClassified;
        }
    }
}
