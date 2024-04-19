xmlport 50004 "Sending File PTT"
{
    DefaultFieldsValidation = false;
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    FileName = 'Zendingenbestand-PTT.csv';
    Format = VariableText;
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                MaxOccurs = Once;
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(HeaderTxt)
                {
                    MaxOccurs = Once;

                    trigger OnBeforePassVariable()
                    begin
                        HeaderTxt := 'YourReference;CompanyName;Surname;FirstName;CountryCode;Street;HouseNo;HouseNoSuffix;Postcode;City;Email;MobileNumber;ProductCode;CODAmount;CODReference;InsuredValue';
                    end;
                }
            }
            tableelement("Rembours etiketten"; "Reimbursement Label")
            {
                XmlName = 'RemboursEtiketten';
                fieldelement(Code; "Rembours etiketten".Code)
                {
                }
                fieldelement(Aflevernaam; "Rembours etiketten".Aflevernaam)
                {
                }
                textelement("dummytxt[1]")
                {
                    XmlName = 'DummyTxt';
                }
                textelement("dummytxt[2]")
                {
                    XmlName = 'DummyTxt';
                }
                fieldelement(Afleverland; "Rembours etiketten".Afleverland)
                {
                }
                fieldelement(Afleveradres; "Rembours etiketten"."Straatnaam afleveradres")
                {
                }
                fieldelement(Afleverhuisnummer; "Rembours etiketten"."Huisnummer afleveradres")
                {
                }
                fieldelement(AfleverhuisnrToevoeging; "Rembours etiketten"."Toevoeging afleveradres")
                {
                }
                fieldelement(Postcode; "Rembours etiketten".Postcode)
                {
                }
                fieldelement(Plaats; "Rembours etiketten".Plaats)
                {
                }
                fieldelement(Email; "Rembours etiketten".Email)
                {
                }
                textelement("dummytxt[3]")
                {
                    XmlName = 'DummyTxt';
                }
                textelement(produktcodetxt)
                {
                    TextType = Text;
                    XmlName = 'ProductCode';

                    trigger OnBeforePassVariable()
                    begin
                        ProduktCodeTxt := '3085';
                    end;
                }
                textelement("dummytxt[5]")
                {
                    XmlName = 'DummyTxt';
                }
                textelement("dummytxt[6]")
                {
                    XmlName = 'DummyTxt';
                }
                textelement("dummytxt[7]")
                {
                    XmlName = 'DummyTxt';
                }

                trigger OnAfterGetRecord()
                begin
                    "Rembours etiketten".PTTEtiketGeprint := true;
                    "Rembours etiketten".MODIFY();
                end;

                trigger OnPreXmlItem()
                begin
                    RemboursetiketRec.RESET();
                    RemboursetiketRec.SetRange(Locatie, '40');
                    RemboursetiketRec.SetFilter(Betalingswijze, '02|03|04|05');

                    RemboursetiketRec.SetRange(PTTEtiketGeprint, false);
                    if RemboursetiketRec.Find('-') then begin
                        repeat
                            AdresString := RemboursetiketRec.Adres;
                            NummerGevonden := false;
                            Positie := StrPos(AdresString, ' ');
                            if Positie > 0 then begin
                                while (NummerGevonden = false) and (Positie < 31) do //atw
                                    if (CopyStr(AdresString, Positie + 1, 1) in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and
                                       (CopyStr(AdresString, Positie, 1) = ' ') then
                                        NummerGevonden := true
                                    else begin
                                        NummerGevonden := false;
                                        Positie := Positie + 1;
                                    end;
                                RemboursetiketRec."Straatnaam afleveradres" := CopyStr(AdresString, 1, Positie - 1);
                                RemboursetiketRec."Huisnummer afleveradres" := CopyStr(AdresString, Positie + 1, 10);
                                // Toevoeging bepalen
                                Positie2 := 0;
                                LaatsteTekenGevonden := false;
                                while (LaatsteTekenGevonden = false) and (Positie2 < 10) do begin
                                    LaatsteTeken := CopyStr(RemboursetiketRec."Huisnummer afleveradres", Positie2 + 1, 1);
                                    //      if NOT (LaatsteTeken IN ['0','1','2','3','4','5','6','7','8','9','-']) THEN
                                    if not (LaatsteTeken in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
                                        LaatsteTekenGevonden := true
                                    else begin
                                        LaatsteTekenGevonden := false;
                                        Positie2 := Positie2 + 1;
                                    end;
                                end;
                                if (LaatsteTekenGevonden = true) then begin
                                    HuisnummerString := RemboursetiketRec."Huisnummer afleveradres";
                                    LengteHuisnummerString := StrLen(HuisnummerString);
                                    RemboursetiketRec."Huisnummer afleveradres" :=
                                                      CopyStr(HuisnummerString, 1, (Positie2));
                                    RemboursetiketRec."Toevoeging afleveradres" :=
                                                      CopyStr(HuisnummerString, (Positie2 + 1), ((LengteHuisnummerString + 1) - Positie2));
                                end else
                                    RemboursetiketRec."Toevoeging afleveradres" := '';
                            end else begin
                                RemboursetiketRec."Straatnaam afleveradres" := AdresString;
                                RemboursetiketRec."Huisnummer afleveradres" := '';
                            end;
                            RemboursetiketRec.MODIFY();
                        until RemboursetiketRec.Next() = 0;
                    end;

                    "Rembours etiketten".RESET();
                    "Rembours etiketten".SetRange(Locatie, '40');

                    "Rembours etiketten".SetFilter(Betalingswijze, '02|03|04|05');
                    "Rembours etiketten".SetRange(PTTEtiketGeprint, false);
                end;
            }

            trigger OnBeforePassVariable()
            begin
                root := 'YourReference;CompanyName;Surname;FirstName;CountryCode;Street;HouseNo;HouseNoSuffix;Postcode;City;Email;MobileNumber;ProductCode;CODAmount;CODReference;InsuredValue';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        DummyTxt: Text[1];
        Positie: Integer;
        NummerGevonden: Boolean;
        HuisnummerString: Code[10];
        AdresString: Text[50];
        LaatsteTeken: Code[1];
        LengteHuisnummerString: Integer;
        RemboursetiketRec: Record "Reimbursement Label";
        Positie2: Integer;
        LaatsteTekenGevonden: Boolean;
}

