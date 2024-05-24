tableextension 50024 "CS Service Comment Line" extends "Service Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = if ("Table Name" = const("Service Contract")) "Service Contract Header"."Contract No."
            else
            if ("Table Name" = const("Service Header")) "Service Header"."No."
            else
            if ("Table Name" = const("Service Item")) "Service Item"
            else
            if ("Table Name" = const(Loaner)) Loaner
            else
            if ("Table Name" = const("Service Line")) "Service Line"."No.";
        }
    }
}
