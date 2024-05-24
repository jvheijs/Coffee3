tableextension 50023 "CS Service Item Line" extends "Service Item Line"
{
    fields
    {
        field(50000; "CS Service Contract Descr."; Text[100])
        {
            Caption = 'Service Contract Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Contract Header".Description where("Contract No." = field("Contract No.")));
            Editable = false;
        }
    }
}
