page 50013 "DP Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(reporting)
        {
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View posted invoices and credit memos, and analyze G/L registers.';
            }
        }
        area(creation)
        {
            action("Page My Customers")
            {
                Caption = 'Mijn klanten';
                Image = CustomerList;
                RunObject = Page "DP My Customers";
                ApplicationArea = All;
            }
            action("Dag overzicht")
            {
                Image = List;
                RunObject = Page Daysheet;
                ApplicationArea = All;
            }
            action("Overzicht niet geboekte verkooporders")
            {
                Image = List;
                RunObject = Page "DP SalesOrderList";
                ApplicationArea = All;
            }
            action("Posted Sales Invoices")
            {
                Caption = 'Posted Sales Invoices';
                Image = PostedOrder;
                RunObject = Page "DP Posted Sales Invoices";
                ApplicationArea = All;
            }

        }
    }
}

