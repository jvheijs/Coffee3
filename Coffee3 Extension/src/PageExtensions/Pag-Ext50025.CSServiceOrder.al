pageextension 50025 "CS Service Order" extends "Service Order"
{
    layout
    {
        modify(Invoicing)
        {
            Visible = false;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        modify(" Foreign Trade")
        {
            Visible = false;
        }
    }

    local procedure HasSignature(): Boolean;
    begin
        rec.get(rec."Document Type", rec."No.");
        rec.CalcFields("Signature");
        exit(Rec."Signature".HasValue);
    end;

    local procedure AddSignature();
    var
        Signature: Page Signature;
    begin
        Signature.SetRecord(Rec);
        Signature.SetWithExit();
        Signature.RunModal();
    end;
}
