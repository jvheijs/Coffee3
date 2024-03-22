pageextension 50014 "CS Posted Sales Invoice" extends "Posted Sales Invoice"
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
        addafter("Ship-to Contact")
        {
            field("Aantal colli"; Rec."Aantal colli")
            {
                ApplicationArea = All;
            }
            field("Remboursformulier geprint"; Rec."Remboursformulier geprint")
            {
                ApplicationArea = All;
            }
            field(Afhalen; Rec.Afhalen)
            {
                ApplicationArea = All;
            }
        }
    }
}
