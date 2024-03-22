tableextension 50003 "CS Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Aantal aanmaningen verstuurd"; Integer)
        {
            caption = 'Quantity Reminders Send';
            FieldClass = FlowField;
            CalcFormula = Count("Reminder/Fin. Charge Entry" WHERE("Customer Entry No." = FIELD("Entry No."), Type = CONST(Reminder)));
            Editable = false;
        }
    }
}
