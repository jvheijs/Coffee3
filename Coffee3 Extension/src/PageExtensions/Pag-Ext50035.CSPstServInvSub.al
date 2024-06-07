pageextension 50035 "CS Pst. Serv. Inv. Sub." extends "Posted Service Invoice Subform"
{

    actions
    {
        addbefore(Dimenions)
        {
            group("Com&ments")
            {
                Caption = 'Com&ments';
                Image = ViewComments;

                action(Faults)
                {
                    ApplicationArea = Service;
                    Caption = 'Faults';
                    Image = Error;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = const("Service Invoice Line"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                      Type = const(Fault);
                    ToolTip = 'View or edit the different fault codes that you can assign to service items. You can use fault codes to identify the different service item faults or the actions taken on service items for each combination of fault area and symptom codes.';
                }
                action(Resolutions)
                {
                    ApplicationArea = Service;
                    Caption = 'Resolutions';
                    Image = Completed;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = const("Service Invoice Line"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                      Type = const(Resolution);
                    ToolTip = 'View or edit the different resolution codes that you can assign to service items. You can use resolution codes to identify methods used to solve typical service problems.';
                }
                action(Internal)
                {
                    ApplicationArea = Service;
                    Caption = 'Internal';
                    Image = Comment;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = const("Service Invoice Line"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                      Type = const(Internal);
                    ToolTip = 'View or register internal comments for the service item. Internal comments are for internal use only and are not printed on reports.';
                }
                action(Accessories)
                {
                    ApplicationArea = Service;
                    Caption = 'Accessories';
                    Image = ServiceAccessories;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = const("Service Invoice Line"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                      Type = const(Accessory);
                    ToolTip = 'View or register comments for the accessories to the service item.';
                }
                action(Loaners)
                {
                    ApplicationArea = Service;
                    Caption = 'Loaners';
                    Image = Loaners;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name" = const("Service Invoice Line"),
                                      "No." = field("Document No."),
                                      "Table Line No." = field("Line No."),
                                      Type = const("Service Item Loaner");
                    ToolTip = 'View or select from items that you lend out temporarily to customers to replace items that they have in service.';
                }
            }
        }

    }
}
