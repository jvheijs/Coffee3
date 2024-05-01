pageextension 50001 "CS Serv. Dispatcher Activities" extends "Service Dispatcher Activities"
{
    layout
    {
        addlast("Service Orders")
        {
            field("CS Service Orders - Today"; Rec."CS Service Orders - Today")
            {
                ApplicationArea = Service;
                DrillDownPageID = "Service Orders";
                ToolTip = 'Specifies the number of in-service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
            }
            field("CS Service Orders - in Process"; Rec."CS Service Orders - in Process")
            {
                ApplicationArea = Service;
                DrillDownPageID = "Service Orders";
                ToolTip = 'Specifies the number of in process service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
            }
            field("CS Service Orders - Finished"; Rec."CS Service Orders - Finished")
            {
                ApplicationArea = Service;
                DrillDownPageID = "Service Orders";
                ToolTip = 'Specifies the finished service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
            }
            field("CS Service Orders - Inactive"; Rec."CS Service Orders - Inactive")
            {
                ApplicationArea = Service;
                DrillDownPageID = "Service Orders";
                ToolTip = 'Specifies the number of inactive service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
            }
        }

        addlast("Service Quotes")
        {
            field("CS Open Service Quotes"; Rec."CS Open Service Quotes")
            {
                ApplicationArea = Service;
                DrillDownPageID = "Service Quotes";
                ToolTip = 'Specifies the number of open service quotes that are displayed in the Service Cue on the Role Center.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetUserFilter();
    end;
}
