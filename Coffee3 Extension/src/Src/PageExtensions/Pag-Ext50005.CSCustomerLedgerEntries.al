pageextension 50005 "CS Customer Ledger Entries" extends "Customer Ledger Entries"
{
    Description = 'CS2.0';

    layout
    {
        addafter("Direct Debit Mandate ID")
        {
            field("Aantal aanmaningen verstuurd"; Rec."Aantal aanmaningen verstuurd")
            {
                ApplicationArea = All;
            }

        }
    }

}
