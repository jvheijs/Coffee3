pageextension 50038 "CS Posted Serv. Invoice Subf" extends "Posted Service Invoice Subform"
{
    actions
    {
        addbefore(Faults)
        {
            action("Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;

                RunObject = Page "Service Comment Sheet";
                RunPageLink = "Table Name" = const("Service Invoice Line"),
                                    "Table Subtype" = filter(0),
                                    "No." = field("Document No."),
                                    "Table Line No." = field("Line No."),
                                    Type = const(General);
                ToolTip = 'View or add comments for the record.';
            }
        }
    }
}
