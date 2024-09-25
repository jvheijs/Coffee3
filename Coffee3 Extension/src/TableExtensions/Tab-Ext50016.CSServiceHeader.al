tableextension 50016 "CS Service Header" extends "Service Header"
{
    Description = 'CS1.0';
    fields
    {

        field(50001; "Status Signing"; enum "CS Status Signing")
        {
            Caption = 'Status Signature';
            DataClassification = CustomerContent;
        }

        field(50020; Verzendprofiel; Code[20])
        {
            Caption = 'Verzendprofiel';
            Description = 'CS1.0';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Document Sending Profile" where("No." = field("Customer No.")));

        }
    }


    procedure UpdateSignStatus(Signed: Boolean)
    begin
        if Signed then begin
            rec."Status Signing" := rec."Status Signing"::Signed;
            rec."Finishing Date" := Today();
            rec."Finishing Time" := Time();
        end else begin
            rec."Status Signing" := rec."Status Signing"::Unsigned;
            rec."Finishing Date" := 0D;
            rec."Finishing Time" := 0T;
        end;
        rec.Modify();
    end;
}
