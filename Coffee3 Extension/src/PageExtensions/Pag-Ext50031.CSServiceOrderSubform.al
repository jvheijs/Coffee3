pageextension 50031 "CS Service Order Subform" extends "Service Order Subform"
{
    layout
    {
        addafter("Contract No.")
        {
            field("CS Service Contract Descr."; rec."CS Service Contract Descr.")
            {
                ApplicationArea = All;
                Caption = 'Service Contract Description';
                Editable = false;
                ToolTip = 'Service Contract Description';
            }
        }
    }

    actions
    {
        addbefore(Faults)
        {
            action("Comments")
            {
                ApplicationArea = Comments;
                Caption = 'Comments';
                Image = ViewComments;

                RunObject = Page "Service Comment Sheet";
                RunPageLink = "Table Name" = const("Service Line"),
                                  "Table Subtype" = field("Document Type"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                  Type = const(General);
                ToolTip = 'View or add comments for the record.';
            }
        }

        addlast("&Line")
        {
            action("Service Item Comments")
            {
                ApplicationArea = Service;
                Caption = 'Service Item Comments';
                Image = ViewComments;
                Enabled = EnableComments;
                RunObject = Page "Service Comment Sheet";
                RunPageLink = "Table Name" = const("Service Item"),
                                  "Table Subtype" = const("0"),
                                  "No." = field("Service Item No.");
                RunPageMode = View;
                ToolTip = 'View or add comments for the related service item.';
            }
        }


    }

    trigger OnAfterGetRecord()
    begin
        EnableComments := rec."Service Item No." <> '';
    end;

    var
        EnableComments: Boolean;
}
