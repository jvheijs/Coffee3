tableextension 50017 "CS Service Invoice Header" extends "Service Invoice Header"
{
    Description = 'CS2.0';
    fields
    {
        field(50020; Verzendprofiel; Code[20])
        {
            Caption = 'Verzendprofiel';
            Description = 'CS1.0';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup(Customer."Document Sending Profile" WHERE("No." = FIELD("Customer No.")));
        }
    }
}
