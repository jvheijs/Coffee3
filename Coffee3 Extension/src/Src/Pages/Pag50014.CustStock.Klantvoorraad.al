page 50014 "CustStock Klantvoorraad"
{
    ApplicationArea = All;
    Caption = 'Klantvoorraad';
    PageType = List;
    SourceTable = "Cust. Stock";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cust. No."; Rec."Cust. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Date field.';
                }
                field("Quantity in stock"; Rec."Quantity in stock")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity in stock field.';
                }
            }
        }
    }
}
