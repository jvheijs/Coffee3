page 50050 Signature
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group("Signature Group")
            {
                usercontrol("SignaturePad"; "CS SignaturePad")
                {
                    ApplicationArea = All;
                    Visible = true;
                    trigger Ready()
                    begin
                        CurrPage."SignaturePad".InitializeSignaturePad();
                    end;

                    trigger Sign(Signature: Text)
                    begin
                        SignDocument(Signature);
                        CurrPage.Update();
                        If WithExit then
                            CurrPage.Close();
                    end;
                }

            }
            field("Signature"; Signature.Signature)
            {
                Caption = 'Signature';
                ToolTip = 'Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetSignature();
        Signature.CalcFields(Signature.Signature);
    end;

    var
        Signature: Record "CS Signature";
        WithExit: Boolean;
        DocNo: Code[20];
        TableNo: Integer;
        DocType: Integer;
        OutStream: OutStream;

    procedure SetWithExit()
    begin
        WithExit := true;
    end;

    procedure SetTable(ForTableNo: Integer)
    begin
        TableNo := ForTableNo;
    end;

    procedure SetDocNo(ForDocNo: Code[20])
    begin
        DocNo := ForDocNo;
    end;

    procedure SetDocType(ForDocType: Integer)
    begin
        DocType := ForDocType
    end;

    local procedure GetSignature(): Boolean
    begin
        exit(Signature.get(TableNo, DocNo, DocType));
    end;

    local procedure SignDocument(var Base64Text: Text)
    var
        Base64Cu: Codeunit "Base64 Convert";
    begin
        Base64Text := Base64Text.Replace('data:image/png;base64,', '');
        Signature.Init();
        Signature."Table No." := TableNo;
        Signature."Document No." := DocNo;
        Signature."Document Type" := DocType;
        Signature.Signature.CreateOutStream(OutStream);
        Base64Cu.FromBase64(Base64Text, OutStream);
        If not Signature.Insert() then
            Signature.Modify();
        GetSignature();
    end;
}

