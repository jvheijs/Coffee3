pageextension 50008 "CS Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Name 2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = All;
            }

        }
        addafter(Status)
        {
            field(Rayon; Rec.Rayon)
            {
                ApplicationArea = All;
            }
            field(Routenummer; Rec.Routenummer)
            {
                ApplicationArea = All;
            }
            field(LocationCode; Rec."Location Code")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        addafter("Payment Terms Code")
        {
            field(PaymentMethodCode; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }

        }
    }
}
