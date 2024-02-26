page 50098 Signature
{
    CaptionML = DEU = 'Unterschrift',
                ENU = 'Signature',
                NLD = 'Handtekening';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Sales Header";

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
                        rec.SignDocument(Signature);
                        CurrPage.Update();
                        If WithExit then
                            CurrPage.Close();
                    end;
                }

            }
            field("Signature"; rec."Signature")
            {
                Caption = 'Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    var
        WithExit: Boolean;


    procedure SetWithExit()
    begin
        WithExit := True;
    end;
}

