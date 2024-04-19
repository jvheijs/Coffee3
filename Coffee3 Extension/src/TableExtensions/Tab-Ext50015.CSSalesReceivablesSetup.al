tableextension 50015 "CS Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; "Name exportdirectory"; Text[250])
        {
            Caption = 'Name exportdirectory';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if (COPYSTR("Name exportdirectory", STRLEN("Name exportdirectory"), 1) <> '\') then
                    "Name exportdirectory" := "Name exportdirectory" + '\';
            end;
        }
        field(50001; "Max. Historie Time"; Code[10])
        {
            Caption = 'Max. Historie Time';
            DataClassification = ToBeClassified;
            DateFormula = true;
        }
        field(50002; "Direct Debit Mandate Nos. Org"; Code[10])
        {
            Caption = 'Direct Debit Mandate Nos.';
            DataClassification = ToBeClassified;
        }
    }
}
