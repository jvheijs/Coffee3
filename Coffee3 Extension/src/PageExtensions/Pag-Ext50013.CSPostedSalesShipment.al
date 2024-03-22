pageextension 50013 "CS Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Shipping Time")
        {
            field("Aantal colli"; Rec."Aantal colli")
            {
                ApplicationArea = All;
            }
        }
    }
}
