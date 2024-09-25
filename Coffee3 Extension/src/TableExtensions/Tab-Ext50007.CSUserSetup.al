tableextension 50007 "CS User Setup" extends "User Setup"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; "Rayon (in verkoopfactuur)"; Integer)
        {
            Description = '2000-902-02 ATW VVK 101000';
            Caption = 'Area (in Sales invoice)';
            TableRelation = "Area and Customerstatus".Rayoncode where(Rayoncode = filter(<> 0));
            DataClassification = ToBeClassified;

        }

        field(50001; "CS Has Wshe. Employee"; boolean)
        {
            Caption = 'Has Warehouse Employee';
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Employee" where("User ID" = field("User ID")));
            Editable = false;
        }
    }
}
