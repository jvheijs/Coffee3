pageextension 50027 "CS Service Invoices" extends "Service Invoices"
{
    layout
    {
        addafter("Payment Method Code")
        {
            field(Verzendprofiel; Rec.Verzendprofiel)
            {
                ApplicationArea = All;
            }
        }
    }
}
