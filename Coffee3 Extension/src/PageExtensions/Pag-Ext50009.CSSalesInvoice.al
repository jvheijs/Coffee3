pageextension 50009 "CS Sales Invoice" extends "Sales Invoice"
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
        addafter("Job Queue Status")
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
        addafter(BillToOptions)
        {
            field("Aantal colli"; Rec."Aantal colli")
            {
                ApplicationArea = All;
            }
            field("Tijd terminal"; Rec."Tijd terminal")
            {
                ApplicationArea = All;
            }
            field("PDT-lijst afgedrukt"; Rec."PDT-lijst afgedrukt")
            {
                ApplicationArea = All;
            }
            field(Afhalen; Rec.Afhalen)
            {
                ApplicationArea = All;
            }
            field(imported; Rec.imported)
            {
                ApplicationArea = All;
            }

        }
    }
}
