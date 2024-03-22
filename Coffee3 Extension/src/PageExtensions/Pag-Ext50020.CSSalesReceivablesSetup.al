pageextension 50020 "CS Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Allow Document Deletion Before")
        {
            field("Name exportdirectory"; Rec."Name exportdirectory")
            {
                ApplicationArea = All;
            }
            field("Max. Historie Time"; Rec."Max. Historie Time")
            {
                ApplicationArea = All;
            }
        }
    }
}
