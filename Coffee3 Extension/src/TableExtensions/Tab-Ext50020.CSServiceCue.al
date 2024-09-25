tableextension 50020 "CS Service Cue" extends "Service Cue"
{
    fields
    {
        field(50000; "CS Service Orders - in Process"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        Status = filter("In Process"),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Service Orders - in Process';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "CS Service Orders - Finished"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        Status = filter(Finished),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Service Orders - Finished';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "CS Service Orders - Inactive"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        Status = filter(Pending | "On Hold"),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Service Orders - Inactive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "CS Open Service Quotes"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Quote),
                                                        Status = filter(Pending | "On Hold"),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Open Service Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "CS Service Orders - Today"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        "Response Date" = field("Date Filter"),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Service Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "CS Ser. Orders - to Follow-up"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        Status = filter("In Process"),
                                                        "Responsibility Center" = field("Responsibility Center Filter"),
                                                        "Location Code" = field("CS Location Filter")));
            Caption = 'Service Orders - to Follow-up';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "CS Location Filter"; code[100])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
        }
    }

    procedure SetLocationFilter()
    var
        WarehouseEmployee: Record "Warehouse Employee";
        FilterString: code[100];
    begin
        WarehouseEmployee.SetRange("User ID", UserId());
        if WarehouseEmployee.FindSet() then
            repeat

                if FilterString <> '' then
                    FilterString += '|' + WarehouseEmployee."Location Code"
                else
                    FilterString := WarehouseEmployee."Location Code";

            until WarehouseEmployee.Next() = 0;

        FilterGroup(2);
        Setfilter("CS Location Filter", FilterString);
        FilterGroup(0);
    end;

}
