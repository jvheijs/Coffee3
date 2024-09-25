tableextension 50025 "CS Service Line" extends "Service Line"
{
    procedure ShowComments(Type: Option General,Fault,Resolution,Accessory,Internal,"Service Item Loaner")
    var
        ServHeader: Record "Service Header";
        ServCommentLine: Record "Service Comment Line";
    begin
        ServHeader.Get(Rec."Document Type", Rec."Document No.");
        ServHeader.TestField("Customer No.");
        TestField("Line No.");

        ServCommentLine.Reset();
        ServCommentLine.SetRange("Table Name", ServCommentLine."Table Name"::"Service Line");
        ServCommentLine.SetRange("Table Subtype", "Document Type");
        ServCommentLine.SetRange("No.", "Document No.");
        ServCommentLine.SetRange("Line No.", Rec."Line No.");
        ServCommentLine.SetRange("Table Line No.", Rec."Service Item Line No.");
        case Type of
            Type::Fault:
                ServCommentLine.SetRange(Type, ServCommentLine.Type::Fault);
            Type::Resolution:
                ServCommentLine.SetRange(Type, ServCommentLine.Type::Resolution);
            Type::Accessory:
                ServCommentLine.SetRange(Type, ServCommentLine.Type::Accessory);
            Type::Internal:
                ServCommentLine.SetRange(Type, ServCommentLine.Type::Internal);
            Type::"Service Item Loaner":
                ServCommentLine.SetRange(Type, ServCommentLine.Type::"Service Item Loaner");
        end;

        PAGE.RunModal(PAGE::"Service Comment Sheet", ServCommentLine);
    end;
}
