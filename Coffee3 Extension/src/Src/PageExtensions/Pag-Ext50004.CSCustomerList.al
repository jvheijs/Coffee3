pageextension 50004 "CS Customer List" extends "Customer List"
{

    layout
    {
        addafter("Country/Region Code")
        {
            field(Rayon; Rec.Rayon)
            {
                ApplicationArea = All;
            }
            field(Routenummer; Rec.Routenummer)
            {
                ApplicationArea = All;
            }
            field(Dropcode; Rec.Dropcode)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Co&mments")
        {
            action(PushCustToDolphin)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Customer;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Condor: Codeunit Condor;
                begin
                    Condor.gFncFillMyCustomer;
                    MESSAGE('Gereed');
                end;
            }
        }
    }
}
