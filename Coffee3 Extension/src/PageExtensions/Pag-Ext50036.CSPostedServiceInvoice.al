pageextension 50036 "CS Posted Service Invoice" extends "Posted Service Invoice"
{
    layout
    {
        addafter("No. Printed")
        {
            field(CSSignature; RecSignature."Signature")
            {
                Caption = 'Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if RecSignature.GET(database::"Service Invoice Header", rec."No.", 0) then
            RecSignature.CalcFields("Signature");
    end;

    var
        RecSignature: Record "CS Signature";
}
