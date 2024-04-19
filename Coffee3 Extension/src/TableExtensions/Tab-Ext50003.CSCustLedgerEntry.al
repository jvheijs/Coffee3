tableextension 50003 "CS Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Aantal aanmaningen verstuurd"; Integer)
        {
            caption = 'Quantity Reminders Send';
            FieldClass = FlowField;
            CalcFormula = count("Reminder/Fin. Charge Entry" where("Customer Entry No." = field("Entry No."), Type = const(Reminder)));
            Editable = false;
        }
    }
}
