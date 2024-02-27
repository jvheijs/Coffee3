tableextension 50013 "CS Customer Bank Account" extends "Customer Bank Account"
{
    Description = 'CS1.0';
    fields
    {
        field(50000; "Direct Debit Mandate ID Org"; Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // CS_UpdateMandateID();
            end;
        }
    }

    //     local procedure CS_UpdateMandateID()
    //     VAR
    //         ProposalLine: Record "Proposal Line";
    //     BEGIN
    //         // Copied from standard local function UpdateMandateID
    //         ProposalLine.SETRANGE("Account Type", ProposalLine."Account Type"::Customer);
    //         ProposalLine.SETRANGE("Account No.", "Customer No.");
    //         ProposalLine.SETRANGE("Bank Account No.", "Bank Account No.");
    //         IF ProposalLine.FINDSET THEN
    //             ProposalLine.MODIFYALL("Direct Debit Mandate ID", "Direct Debit Mandate ID")
    //     end;
}
