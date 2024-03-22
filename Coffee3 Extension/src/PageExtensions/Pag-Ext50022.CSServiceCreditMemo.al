pageextension 50022 "CS Service Credit Memo" extends "Service Credit Memo"
{
    layout
    {
        addafter("Bank Account Code")
        {
            field(PaymentMethodCode; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }

        }
    }

}
