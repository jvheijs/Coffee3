xmlport 50002 "Import Terminal"
{
    // CS1.0         061217 JvH : Gemaakt.
    // CS1.0         140218 JvH : Aangepast n.a.v. mail Marc.
    // CS1.0         020518 JvH : Drie datumvelden lateer in de code gezet, anders worden ze veranderd.
    // CS1.1         110718 JvH : Veld "Posting No." vullen met factuurnr., zodat geboekt nummer hetzelfde blijft.
    // CS-W-1901_006 150119 JvH : Zorgen dat de import verkooporders creert i.p.v. verkoopfacturen.
    // CS2.0         230719 JvH : Orderdatum ook overgenomen uit importbestand.

    DefaultFieldsValidation = false;
    Direction = Import;
    Format = FixedText;

    schema
    {
        textelement(root)
        {
            tableelement("Import terminal"; "Import terminal")
            {
                XmlName = 'Import_Terminal';
                fieldelement(Import_Omschrijving; "Import terminal".Omschrijving)
                {
                    Width = 50;
                }
            }
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

    trigger OnPostXmlPort()
    begin

        // gegevens importbestand bewerken
        RecImportTerminal.RESET();
        if RecImportTerminal.FindSet() then begin
            repeat
                SoortRegel := CopyStr(RecImportTerminal.Omschrijving, 1, 2);
                case true of
                    SoortRegel = Text60000:
                        RecImportTerminal.DELETE();
                    SoortRegel = Text60001:
                        RecImportTerminal.DELETE();
                    SoortRegel = ' ':
                        RecImportTerminal.DELETE();
                    SoortRegel = Text60011:
                        begin
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.MODIFY();
                        end;
                    SoortRegel = Text60012:
                        begin
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.MODIFY();
                        end;
                    SoortRegel = Text60013:
                        begin
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.MODIFY();
                        end;
                    SoortRegel = Text60002:
                        begin
                            if StrLen(RecImportTerminal.Omschrijving) = 39 then
                                RecImportTerminal.Omschrijving := CopyStr(RecImportTerminal.Omschrijving, 1, 4) +
                                                                  '00' +
                                                                  CopyStr(RecImportTerminal.Omschrijving, 5);
                            FactuurNummerHeader := CopyStr(RecImportTerminal.Omschrijving, 3, 9);
                            RecImportTerminal.Factuurnummer := FactuurNummerHeader;
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.Omschrijving := ConvertStr(RecImportTerminal.Omschrijving, '.', ',');
                            RecImportTerminal.MODIFY();
                        end;
                    SoortRegel = Text60003:
                        begin
                            RecImportTerminal.Factuurnummer := FactuurNummerHeader;
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.Omschrijving := ConvertStr(RecImportTerminal.Omschrijving, '.', ',');
                            RecImportTerminal.MODIFY();
                        end;
                    SoortRegel = Text60004:
                        begin
                            if StrLen(RecImportTerminal.Omschrijving) = 39 then
                                RecImportTerminal.Omschrijving := CopyStr(RecImportTerminal.Omschrijving, 1, 4) +
                                                                  '00' +
                                                                  CopyStr(RecImportTerminal.Omschrijving, 5);
                            FactuurNummerHeader := CopyStr(RecImportTerminal.Omschrijving, 3, 9);
                            RecImportTerminal.Factuurnummer := FactuurNummerHeader;
                            RecImportTerminal.Regelsoort := SoortRegel;
                            RecImportTerminal.Omschrijving := ConvertStr(RecImportTerminal.Omschrijving, '.', ',');
                            RecImportTerminal.MODIFY();
                        end;
                end;
            until RecImportTerminal.Next() = 0;
        end;

        // factuurkop aanmaken
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60002);
        if RecImportTerminal.FindSet() then begin
            repeat
                InvoerenFactuurKop;
            until RecImportTerminal.Next() = 0;
        end;

        // factuurregel aanmaken
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60003);
        if RecImportTerminal.FindSet() then begin
            repeat
                InvoerenFactuurRegel;
            until RecImportTerminal.Next() = 0;
        end;

        // Openstaande posten verwerken
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60004);
        if RecImportTerminal.FindSet() then begin
            repeat
                VerwerkenOpenstaandePosten;
            until RecImportTerminal.Next() = 0;
            // REPORT.RUN(REPORT::"Openstaande facturen gevonden",FALSE,TRUE);  // CS1.0 niet meer nodig
        end;

        //Verwerken leesbevestigingen
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60011);
        if RecImportTerminal.FindSet() then begin
            repeat
                VerwerkenLeesbevestigingen;
            until RecImportTerminal.Next() = 0;
            REPORT.Run(REPORT::"Read Confirmation Found", false, true);    // CS1.0
        end;

        //Verwerken Klantbezoeken
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60012);
        if RecImportTerminal.FindSet() then begin
            repeat
                VerwerkenKlantbezoeken;
            until RecImportTerminal.Next() = 0;
            REPORT.Run(REPORT::"Customer Visit Found", false, true);       // CS1.0
        end;

        //Verwerken klantvoorraden
        RecImportTerminal.RESET();
        RecImportTerminal.SetCurrentKey(RecImportTerminal.Regelsoort);
        RecImportTerminal.SetRange(Regelsoort, Text60013);
        if RecImportTerminal.FindSet() then begin
            repeat
                VerwerkenKlantvoorraden;
            until RecImportTerminal.Next() = 0;
            REPORT.Run(REPORT::"Customer Inventory Found", false, true);    // CS1.0
        end;

        //Provisietabel vullen
        VerkoopkopLijst2.RESET();
        if VerkoopkopLijst2.FindSet() then
            repeat
                Provisie2.RESET();
                Provisie2.SetCurrentKey(Provisie2.Rayon, Provisie2.Route, Provisie2.Datum);
                Provisie2.SetRange(Provisie2.Rayon, VerkoopkopLijst2.Rayon);
                Provisie2.SetRange(Provisie2.Route, VerkoopkopLijst2.Routenummer);
                Provisie2.SetRange(Provisie2.Datum, VerkoopkopLijst2."Posting Date");
                if not Provisie2.FINDFIRST() then begin
                    AantalProvisie := 0;
                    AantalAdressen := 0;
                    // CS1.0
                    AantalAdressenFullS := 0;
                    AantalAdressenServ := 0;

                    NoOfServiceOrdersGL := 0;
                    NoOfDoubleOrdersGL := 0;
                    KlantRec2GL.RESET();
                    KlantRec2GL.DELETEALL();

                    VerkoopkopLijst.RESET();
                    VerkoopkopLijst.SetCurrentKey(VerkoopkopLijst.Rayon, VerkoopkopLijst.Routenummer, VerkoopkopLijst."Posting Date");
                    VerkoopkopLijst.SetRange(VerkoopkopLijst.Rayon, VerkoopkopLijst2.Rayon);
                    VerkoopkopLijst.SetRange(VerkoopkopLijst.Routenummer, VerkoopkopLijst2.Routenummer);
                    VerkoopkopLijst.SetRange(VerkoopkopLijst."Posting Date", VerkoopkopLijst2."Posting Date");
                    if VerkoopkopLijst.FindSet() then
                        repeat
                            AantalProvisie := AantalProvisie + 1;
                        until VerkoopkopLijst.Next() = 0;

                    Klantrec.RESET();
                    Klantrec.SetCurrentKey(Klantrec.Rayon, Klantrec.Routenummer);
                    Klantrec.SetRange(Klantrec.Rayon, VerkoopkopLijst2.Rayon);
                    Klantrec.SetRange(Klantrec.Routenummer, VerkoopkopLijst2.Routenummer);
                    if Klantrec.FindSet() then
                        repeat
                            AantalAdressen := AantalAdressen + 1;
                            // CS1.0
                            if Klantrec."Global Dimension 1 Code" = 'FULL SERVICE' then
                                AantalAdressenFullS := AantalAdressenFullS + 1;
                            if Klantrec."Global Dimension 1 Code" = 'SERVICE' then
                                AantalAdressenServ := AantalAdressenServ + 1;
                        until Klantrec.Next() = 0;

                    SalesHeaderRec.RESET();
                    SalesHeaderRec.SetCurrentKey(Rayon, Routenummer, "Posting Date");
                    SalesHeaderRec.SetRange(Rayon, VerkoopkopLijst2.Rayon);
                    SalesHeaderRec.SetRange(Routenummer, VerkoopkopLijst2.Routenummer);
                    SalesHeaderRec.SetRange("Posting Date", VerkoopkopLijst2."Posting Date");
                    if SalesHeaderRec.FindSet() then begin
                        repeat
                            if not KlantRec2GL.Get(SalesHeaderRec."Sell-to Customer No.") then begin
                                KlantRec2GL.INIT();
                                KlantRec2GL."No." := SalesHeaderRec."Sell-to Customer No.";
                                KlantRec2GL.INSERT();
                            end else begin
                                NoOfDoubleOrdersGL := NoOfDoubleOrdersGL + 1;
                            end;

                        until SalesHeaderRec.Next() = 0;
                    end;

                    Provisie.RESET();
                    Provisie.SetCurrentKey(Provisie.Regelnummer);
                    Provisie.SetRange(Provisie.Regelnummer);
                    if Provisie.FINDLAST() then
                        LaatsteRegel := Provisie.Regelnummer
                    else
                        LaatsteRegel := 0;

                    Provisie.INIT();
                    Provisie.Regelnummer := LaatsteRegel + 1;
                    Provisie.Datum := VerkoopkopLijst2."Posting Date";
                    Provisie.Rayon := VerkoopkopLijst2.Rayon;
                    Provisie.Route := VerkoopkopLijst2.Routenummer;
                    Provisie."Aantal adressen in route" := AantalAdressen;
                    // CS1.0 BKR 20180627
                    Provisie."Aantal fulls adressen in route" := AantalAdressenFullS;
                    Provisie."Aantal serv adressen in route" := AantalAdressenServ;

                    Provisie."Aantal gescoorde orders" := AantalProvisie;
                    Provisie."Double Orders" := NoOfDoubleOrdersGL;
                    Provisie."Service Orders" := NoOfServiceOrdersGL;
                    Provisie.INSERT();
                end;
            until VerkoopkopLijst2.Next() = 0;


        //PDT-lijst uitprinten
        VerkoopkopLijst.RESET();
        VerkoopkopLijst.SetCurrentKey(VerkoopkopLijst."PDT-lijst afgedrukt");
        VerkoopkopLijst.SetRange(VerkoopkopLijst."PDT-lijst afgedrukt", false);
        if VerkoopkopLijst.FINDFIRST() then
            REPORT.Run(REPORT::"PDT-List", false, true, VerkoopkopLijst); // CS1.0

        if VerkoopkopLijst.FINDFIRST() then
            repeat
                VerkoopkopLijst."PDT-lijst afgedrukt" := true
            until VerkoopkopLijst.Next() = 0;

        // zaaknummerslijst uitdraaien
        VKRep.RESET();
        if VKRep.FINDFIRST() then
            REPORT.Run(REPORT::"Case Number List", false, true, VKRep);  // CS1.0 wel nodig
        Message('Klaar');
    end;

    trigger OnPreXmlPort()
    begin
        ImpTermRec.DELETEALL();
    end;

    var
        Volgnummer: Integer;
        ImpTermRec: Record "Import terminal";
        RecImportTerminal: Record "Import terminal";
        RecImportTerminal2: Record "Import terminal";
        SoortRegel: Text[2];
        FactuurNummerHeader: Code[10];
        FactuurHeader: Code[2];
        FactuurRegel: Code[2];
        RecVerkKop: Record "Sales Header";
        RecVerkRegel: Record "Sales Line";
        RecVerkRegel2: Record "Sales Line";
        RecVerkoopfactuur: Record "Sales Invoice Header";
        OPBetalingswijze: Code[10];
        RecKlantenPost: Record "Cust. Ledger Entry";
        KlantNummer: Code[10];
        DagbRegel: Record "Gen. Journal Line";
        VerkoopkopLijst: Record "Sales Header";
        VerkoopkopLijst2: Record "Sales Header";
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        ItemRec2: Record Item;
        Klantrec: Record Customer;
        KlantRec2GL: Record Customer temporary;
        AantalProvisie: Integer;
        AantalAdressen: Integer;
        AantalAdressenFullS: Integer;
        AantalAdressenServ: Integer;
        NoOfServiceOrdersGL: Integer;
        NoOfDoubleOrdersGL: Integer;
        Provisie: Record Provision;
        LaatsteRegel: Integer;
        Provisie2: Record Provision;
        RecVerkKop2: Record "Sales Header";
        NrReeksBeheer: Codeunit NoSeriesManagement;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        RecKlantenPost2: Record "Cust. Ledger Entry";
        LaatsteRegelNummer: Integer;
        Dagboekbatch: Record "Gen. Journal Batch";
        VKRep: Record "Sales Header";
        OtherItemLines: Boolean;
        Text60000: Label 'II';
        Text60001: Label 'en';
        Text60002: Label 'FH';
        Text60003: Label 'FR';
        Text60004: Label 'FO';
        Text60005: Label 'Factuur ';
        Text60006: Label 'KLANT';
        Text60007: Label 'ALGEMEEN';
        Text60008: Label 'STANDAARD';
        Text60009: Label 'FDAGB';
        Text60010: Label 'STUKNRMEM';
        Text60011: Label 'LL';
        Text60012: Label 'ZZ';
        Text60013: Label 'OO';
        Text60014: Label 'Imported';

    procedure InvoerenFactuurKop()
    var
        VarTijd: Time;
        VarDatum: Date;
        Waarde1: Text[30];
        Waarde2: Text[30];
        VarBedrag: Decimal;
        Waarde3: Text[30];
        OK1: Boolean;
        OK2: Boolean;
        OK3: Boolean;
        Teken: Code[1];
        Waarde4: Text[30];
        Waarde5: Text[30];
        VarRoute: Integer;
        VarRayon: Integer;
    begin
        if StrLen(RecImportTerminal.Omschrijving) = 39 then
            RecImportTerminal.Omschrijving := CopyStr(RecImportTerminal.Omschrijving, 1, 4) +
                                              '00' +
                                              CopyStr(RecImportTerminal.Omschrijving, 5);

        Waarde1 := CopyStr(RecImportTerminal.Omschrijving, 19, 6);        // datum
        Waarde2 := CopyStr(RecImportTerminal.Omschrijving, 25, 4);        // tijd
        Waarde3 := CopyStr(RecImportTerminal.Omschrijving, 30, 10);       // totaalbedrag
        Waarde4 := CopyStr(RecImportTerminal.Omschrijving, 3, 2);       // rayon
        Waarde5 := CopyStr(RecImportTerminal.Omschrijving, 40, 2);       // route
        //einde


        Evaluate(VarDatum, Waarde1);
        Evaluate(VarTijd, Waarde2);
        Evaluate(VarBedrag, Waarde3);

        Evaluate(VarRoute, Waarde5);
        Evaluate(VarRayon, Waarde4);

        Teken := CopyStr(RecImportTerminal.Omschrijving, 29, 1);

        RecVerkKop.RESET();
        RecVerkKop.INIT();
        if Teken = '+' then begin
            //RecVerkKop."Document Type" := RecVerkKop."Document Type"::Invoice;
            RecVerkKop."Document Type" := RecVerkKop."Document Type"::Order;                  // CS-W-1901_006
            RecImportTerminal2.RESET();
            RecImportTerminal2.SetRange(Regelsoort, Text60003);
            RecImportTerminal2.SetRange(Factuurnummer, RecImportTerminal.Factuurnummer);
            if RecImportTerminal2.Find('-') then begin
                repeat
                    RecImportTerminal2.Factuur := true;
                    RecImportTerminal2.MODIFY();
                until RecImportTerminal2.Next() = 0;
            end;
        end else begin
            //RecVerkKop."Document Type" := RecVerkKop."Document Type"::"Credit Memo";
            RecVerkKop."Document Type" := RecVerkKop."Document Type"::"Return Order";         // CS-W-1901_006
            RecImportTerminal2.RESET();
            RecImportTerminal2.SetRange(Regelsoort, Text60003);
            RecImportTerminal2.SetRange(Factuurnummer, RecImportTerminal.Factuurnummer);
            if RecImportTerminal2.Find('-') then begin
                repeat
                    RecImportTerminal2.Creditnota := true;
                    RecImportTerminal2.MODIFY();
                until RecImportTerminal2.Next() = 0;
            end;
        end;

        // CS1.0
        RecVerkKop."Posting Date" := VarDatum;
        RecVerkKop."Document Date" := VarDatum;
        RecVerkKop."Shipment Date" := VarDatum;
        RecVerkKop."Order Date" := VarDatum;        // CS2.0

        RecVerkKop."No." := CopyStr(RecImportTerminal.Omschrijving, 3, 9);
        RecVerkKop."Posting Description" := Text60005 + RecVerkKop."No.";
        RecVerkKop.imported := true;
        RecVerkKop.Validate("Sell-to Customer No.", CopyStr(RecImportTerminal.Omschrijving, 12, 6));

        RecVerkKop.CreateDimFromDefaultDim(RecVerkKop.FieldNo("Salesperson Code"));
        RecVerkKop.CreateDimFromDefaultDim(RecVerkKop.FieldNo("Bill-to Customer No."));
        RecVerkKop.CreateDimFromDefaultDim(RecVerkKop.FieldNo("Campaign No."));
        RecVerkKop.CreateDimFromDefaultDim(RecVerkKop.FieldNo("Responsibility Center"));
        RecVerkKop.CreateDimFromDefaultDim(RecVerkKop.FieldNo("Bill-to Customer Templ. Code"));

        RecVerkKop.Rayon := VarRayon;
        RecVerkKop.Routenummer := VarRoute;
        RecVerkKop."Payment Method Code" := CopyStr(RecImportTerminal.Omschrijving, 18, 1);
        if RecVerkKop."Payment Method Code" = '0' then
            RecVerkKop."Payment Method Code" := '1';
        RecVerkKop."Payment Method Code" := '0' + RecVerkKop."Payment Method Code";
        RecVerkKop.Validate(RecVerkKop."Payment Method Code");
        RecVerkKop."Tijd terminal" := VarTijd;


        RecVerkKop."Posting Date" := VarDatum;
        RecVerkKop."Document Date" := VarDatum;
        RecVerkKop."Shipment Date" := VarDatum;
        RecVerkKop."Order Date" := VarDatum;                      // CS2.0

        // CS1.1
        RecVerkKop."Posting No." := RecVerkKop."No.";
        // CS1.1

        RecVerkKop.INSERT();
    end;

    procedure InvoerenFactuurRegel()
    var
        RegelNummer: Integer;
        VarStukPrijs: Decimal;
        Waarde1: Text[30];
        Teken: Text[1];
        VarAantal: Integer;
        Waarde2: Text[30];
    begin

        if RecImportTerminal.Factuur = true then begin
            RecVerkKop2.RESET();
            RecVerkKop2.SetCurrentKey(RecVerkKop2."Document Type", RecVerkKop2."No.");
            //RecVerkKop2.SETRANGE(RecVerkKop2."Document Type",RecVerkRegel."Document Type"::Invoice);
            RecVerkKop2.SetRange(RecVerkKop2."Document Type", RecVerkRegel."Document Type"::Order);            // CS-W-1901_006
            RecVerkKop2.SetRange(RecVerkKop2."No.", RecImportTerminal.Factuurnummer);
            if RecVerkKop2.FINDFIRST() then
                ReleaseSalesDoc.Reopen(RecVerkKop2);
        end;
        if RecImportTerminal.Creditnota = true then begin
            RecVerkKop2.RESET();
            RecVerkKop2.SetCurrentKey(RecVerkKop2."Document Type", RecVerkKop2."No.");
            //RecVerkKop2.SETRANGE(RecVerkKop2."Document Type",RecVerkRegel."Document Type"::"credit memo");
            RecVerkKop2.SetRange(RecVerkKop2."Document Type", RecVerkRegel."Document Type"::"Return Order");  // CS-W-1901_006
            RecVerkKop2.SetRange(RecVerkKop2."No.", RecImportTerminal.Factuurnummer);
            if RecVerkKop2.FINDFIRST() then
                ReleaseSalesDoc.Reopen(RecVerkKop2);
        end;

        Teken := CopyStr(RecImportTerminal.Omschrijving, 7, 1);

        Waarde1 := CopyStr(RecImportTerminal.Omschrijving, 11, 10);       // stukprijs
        Evaluate(VarStukPrijs, Waarde1);

        Waarde2 := CopyStr(RecImportTerminal.Omschrijving, 8, 2);         // aantal
        Evaluate(VarAantal, Waarde2);

        RecVerkRegel.RESET();
        RecVerkRegel.INIT();
        if RecImportTerminal.Factuur = true then
            //RecVerkRegel."Document Type" := RecVerkRegel."Document Type"::Invoice;
            RecVerkRegel."Document Type" := RecVerkRegel."Document Type"::Order;                 // CS-W-1901_006
        if RecImportTerminal.Creditnota = true then
            //RecVerkRegel."Document Type" := RecVerkRegel."Document Type"::"Credit Memo";
            RecVerkRegel."Document Type" := RecVerkRegel."Document Type"::"Return Order";        // CS-W-1901_006

        RecVerkRegel."Document No." := RecImportTerminal.Factuurnummer;
        RecVerkRegel2.RESET();
        RecVerkRegel2.SetRange("Document Type", RecVerkRegel."Document Type");
        RecVerkRegel2.SetRange("Document No.", RecVerkRegel."Document No.");
        if RecVerkRegel2.Find('+') then
            RegelNummer := RecVerkRegel2."Line No." + 10000
        else
            RegelNummer := 10000;
        RecVerkRegel."Line No." := RegelNummer;
        RecVerkRegel.INSERT();                                                                   // CS-W-1901_006
        RecVerkRegel.Type := RecVerkRegel.Type::Item;
        RecVerkRegel."No." := CopyStr(RecImportTerminal.Omschrijving, 3, 4);
        RecVerkRegel.Validate(RecVerkRegel."No.");

        //if RecVerkRegel."Document Type" = RecVerkRegel."Document Type"::Invoice THEN BEGIN
        if RecVerkRegel."Document Type" = RecVerkRegel."Document Type"::Order then begin             // CS-W-1901_006
            if Teken = '+' then
                RecVerkRegel.Validate(Quantity, VarAantal)                                                 // CS-W-1901_006
            else
                RecVerkRegel.Validate(Quantity, -VarAantal);                                               // CS-W-1901_006
        end else begin
            if Teken = '+' then
                RecVerkRegel.Validate(Quantity, -VarAantal)                                                // CS-W-1901_006
            else
                RecVerkRegel.Validate(Quantity, VarAantal);                                                // CS-W-1901_006
        end;
        // RecVerkRegel.VALIDATE(RecVerkRegel.Quantity);                                             // CS-W-1901_006

        if VarAantal > 0 then
            RecVerkRegel."Unit Price" := (Abs(VarStukPrijs) / VarAantal);

        RecVerkRegel.Validate(RecVerkRegel."Unit Price");
        RecVerkRegel."Location Code" := CopyStr(RecImportTerminal.Factuurnummer, 1, 2);
        RecVerkKop2.RESET();
        RecVerkKop2.SetRange("Document Type", RecVerkRegel."Document Type");
        RecVerkKop2.SetRange("No.", RecVerkRegel."Document No.");
        if RecVerkKop2.FINDFIRST() then
            RecVerkKop2."Location Code" := RecVerkRegel."Location Code";
        ReleaseSalesDoc.Reopen(RecVerkKop2);
        RecVerkKop2.MODIFY();
        RecVerkKop2.RESET();

        //RecVerkKop2.SETRANGE("Document Type",RecVerkKop2."Document Type"::"Credit Memo");
        RecVerkKop2.SetRange("Document Type", RecVerkKop2."Document Type"::"Return Order");           // CS-W-1901_006
        RecVerkKop2.SetRange(RecVerkKop2."No.", RecVerkRegel."Document No.");
        if RecVerkKop2.FINDFIRST() then
            RecVerkKop2."Location Code" := RecVerkRegel."Location Code";
        RecVerkKop2.MODIFY();
        //RecVerkRegel.INSERT();
        RecVerkRegel.MODIFY();                                                                         // CS-W-1901_006

        ReleaseSalesDoc.Run(RecVerkKop2);
    end;

    procedure VerwerkenOpenstaandePosten()
    begin
        FactuurNummerHeader := CopyStr(RecImportTerminal.Omschrijving, 3, 9);
        OPBetalingswijze := CopyStr(RecImportTerminal.Omschrijving, 18, 1);
        OPBetalingswijze := '0' + OPBetalingswijze;

        RecVerkoopfactuur.RESET();
        RecVerkoopfactuur.SetRange("No.", FactuurNummerHeader);
        if RecVerkoopfactuur.FINDFIRST() then begin
            if (RecVerkoopfactuur."Payment Method Code" <> OPBetalingswijze) then begin
                case true of
                    (RecVerkoopfactuur."Payment Method Code" = '02') and (OPBetalingswijze = '04'):
                        begin
                            KlantenPostBijwerken;
                        end;
                    (RecVerkoopfactuur."Payment Method Code" = '03') and (OPBetalingswijze = '04'):
                        begin
                            KlantenPostBijwerken;
                        end;
                    (RecVerkoopfactuur."Payment Method Code" = '04') and ((OPBetalingswijze = '02') or (OPBetalingswijze = '03')):
                        begin
                            KlantenPostBijwerken;
                        end;
                    (RecVerkoopfactuur."Payment Method Code" = '02') and (OPBetalingswijze = '01'):
                        begin
                            KlantenPostBijwerken;
                            MemoriaalEnVereffenen;
                        end;
                    (RecVerkoopfactuur."Payment Method Code" = '03') and (OPBetalingswijze = '01'):
                        begin
                            KlantenPostBijwerken;
                            MemoriaalEnVereffenen;
                        end;
                    (RecVerkoopfactuur."Payment Method Code" = '04') and (OPBetalingswijze = '01'):
                        begin
                            KlantenPostBijwerken;
                            MemoriaalEnVereffenen;
                        end;
                end;
            end;
            RecVerkoopfactuur."Payment Method Code" := OPBetalingswijze;
            RecVerkoopfactuur.MODIFY();
            RecImportTerminal."Openstaande factuur gevonden" := true;
            RecImportTerminal.MODIFY();
        end;
    end;


    procedure KlantenPostBijwerken()
    begin
        KlantNummer := CopyStr(RecImportTerminal.Omschrijving, 12, 6);

        RecKlantenPost.RESET();
        RecKlantenPost.SetCurrentKey("Document Type", "Document No.", "Customer No.");
        RecKlantenPost.SetRange("Document Type", RecKlantenPost."Document Type"::Invoice);
        RecKlantenPost.SetRange("Document No.", RecVerkoopfactuur."No.");
        RecKlantenPost.SetRange("Customer No.", KlantNummer);
        if RecKlantenPost.FINDFIRST() then begin
            if OPBetalingswijze = '04' then
                RecKlantenPost."Transaction Mode Code" := Text60006
            else
                RecKlantenPost."Transaction Mode Code" := '';
            RecKlantenPost.MODIFY();
        end;
    end;


    procedure MemoriaalEnVereffenen()
    var
        VarDatum: Date;
        Waarde1: Text[30];
        Teken: Code[1];
        Waarde2: Text[30];
        VarBedrag: Decimal;
    begin
        Waarde1 := CopyStr(RecImportTerminal.Omschrijving, 19, 6);        // datum
        Evaluate(VarDatum, Waarde1);

        Waarde2 := CopyStr(RecImportTerminal.Omschrijving, 30, 10);       // totaalbedrag
        Evaluate(VarBedrag, Waarde2);

        Teken := CopyStr(RecImportTerminal.Omschrijving, 29, 1);

        // Laatste regelnummer opzoeken
        DagbRegel.RESET();
        DagbRegel.SetRange("Journal Template Name", Text60007);
        DagbRegel.SetRange("Journal Batch Name", Text60008);
        if DagbRegel.FINDLAST() then
            LaatsteRegelNummer := DagbRegel."Line No." + 10000
        else
            LaatsteRegelNummer := 10000;

        // Dagboekregel maken
        DagbRegel.INIT();
        DagbRegel."Journal Template Name" := Text60007;
        DagbRegel."Journal Batch Name" := Text60008;
        DagbRegel."Line No." := LaatsteRegelNummer;
        DagbRegel."Posting Date" := RecVerkoopfactuur."Posting Date";
        DagbRegel."Document Type" := DagbRegel."Document Type"::Payment;
        Dagboekbatch.RESET();
        Dagboekbatch.SetRange("Journal Template Name", Text60007);
        Dagboekbatch.SetRange(Name, Text60008);
        if Dagboekbatch.FINDFIRST() then begin
            DagbRegel."Document No." := NrReeksBeheer.GetNextNo(Dagboekbatch."Posting No. Series", DagbRegel."Posting Date", true);
        end;
        DagbRegel."Account Type" := DagbRegel."Account Type"::Customer;
        DagbRegel."Account No." := RecVerkoopfactuur."Sell-to Customer No.";
        DagbRegel."Bal. Account Type" := DagbRegel."Bal. Account Type"::"G/L Account";
        DagbRegel."Bal. Account No." := '10005';
        DagbRegel."Currency Code" := RecVerkoopfactuur."Currency Code";
        // Te vereffenen klantenpost erbij zoeken
        RecKlantenPost2.RESET();
        RecKlantenPost2.SetCurrentKey("Document Type", "Document No.", "Customer No.");
        RecKlantenPost2.SetRange("Document Type", RecKlantenPost."Document Type"::Invoice);
        RecKlantenPost2.SetRange("Document No.", RecVerkoopfactuur."No.");
        RecKlantenPost2.SetRange("Customer No.", RecVerkoopfactuur."Sell-to Customer No.");
        if RecKlantenPost2.Find('-') then begin
            //  DagbRegel.Vereffeningssoort := DagbRegel.Vereffeningssoort::Factuur;
            DagbRegel.Description := RecKlantenPost2.Description;
            DagbRegel."Document Date" := VarDatum;
            if Teken = '+' then
                DagbRegel.Amount := -VarBedrag
            else
                DagbRegel.Amount := VarBedrag;
            DagbRegel.Validate(DagbRegel.Amount);
            DagbRegel."Applies-to ID" := DagbRegel."Document No.";
            DagbRegel."Posting Group" := RecKlantenPost2."Customer Posting Group";

            DagbRegel."Source Code" := Text60009;
            DagbRegel."Due Date" := RecKlantenPost2."Due Date";
            DagbRegel."Source Type" := DagbRegel."Source Type"::Customer;
            DagbRegel."Source No." := RecKlantenPost2."Customer No.";
            DagbRegel."Posting No. Series" := Text60010;
            RecKlantenPost2."Applies-to ID" := DagbRegel."Document No.";
            // ATW BCO 160201
            RecKlantenPost2."Transaction Mode Code" := '';
            RecKlantenPost2.MODIFY();
            DagbRegel.INSERT();
        end;
    end;


    procedure VerwerkenLeesbevestigingen()
    var
        "CustNo.": Code[6];
        Messdate: Date;
        Confdate: Date;
        CustMessRec: Record "Cust. Messages";
    begin
        "CustNo." := CopyStr(RecImportTerminal.Omschrijving, 3, 6);
        Evaluate(Messdate, CopyStr(RecImportTerminal.Omschrijving, 9, 2) + CopyStr(RecImportTerminal.Omschrijving, 11, 2) +
                                  CopyStr(RecImportTerminal.Omschrijving, 13, 2));
        Evaluate(Confdate, CopyStr(RecImportTerminal.Omschrijving, 15, 2) + CopyStr(RecImportTerminal.Omschrijving, 17, 2) +
                                  CopyStr(RecImportTerminal.Omschrijving, 19, 2));

        CustMessRec.RESET();
        if CustMessRec.Get("CustNo.", Messdate) then begin
            CustMessRec."Confirm Date" := Confdate;
            CustMessRec.MODIFY();
        end;
    end;


    procedure VerwerkenKlantbezoeken()
    var
        VisitRec: Record Visited;
        OnderhoudRec: Record "Maintenance Reg. Machinery";
        OnderhoudsRegRec: Record "Maintenance Registration Line";
        OnderhoudsRegInsRec: Record "Maintenance Registration Line";
        "Cust.No.": Code[20];
        "Date Visited": Date;
        "Time Visited": Time;
        "Doc. No": Code[20];
        "Serial No.": Code[10];
        Description: Text[19];
        "RegelNr.": Integer;
    begin
        if ((StrLen(RecImportTerminal.Omschrijving) = 35) or
            (StrLen(RecImportTerminal.Omschrijving) = 50)) then
            RecImportTerminal.Omschrijving := CopyStr(RecImportTerminal.Omschrijving, 1, 20) +
                                              '00' +
                                              CopyStr(RecImportTerminal.Omschrijving, 21);

        "Cust.No." := CopyStr(RecImportTerminal.Omschrijving, 3, 6);
        Evaluate("Date Visited", CopyStr(RecImportTerminal.Omschrijving, 9, 2) + CopyStr(RecImportTerminal.Omschrijving, 11, 2) +
                                CopyStr(RecImportTerminal.Omschrijving, 13, 2));
        Evaluate("Time Visited", CopyStr(RecImportTerminal.Omschrijving, 15, 4));
        "Doc. No" := CopyStr(RecImportTerminal.Omschrijving, 19, 9);
        "Serial No." := CopyStr(RecImportTerminal.Omschrijving, 28, 10);
        Description := CopyStr(RecImportTerminal.Omschrijving, 38, 15);

        if not VisitRec.Get("Cust.No.", "Date Visited", "Time Visited") then begin
            VisitRec.INIT();
            VisitRec."Cust. No." := "Cust.No.";
            VisitRec."Date Visited" := "Date Visited";
            VisitRec."Time Visited" := "Time Visited";
            VisitRec."Document No." := "Doc. No";
            VisitRec.INSERT();
        end;

        if ("Serial No." <> '') and (Description <> '') then begin
            OnderhoudRec.SetCurrentKey(OnderhoudRec.Klantnummer, OnderhoudRec.Serienummer);
            OnderhoudRec.SetRange(OnderhoudRec.Klantnummer, "Cust.No.");
            OnderhoudRec.SetRange(OnderhoudRec.Serienummer, "Serial No.");
            if OnderhoudRec.Find('-') then begin
                OnderhoudsRegRec.SetCurrentKey(OnderhoudsRegRec."Onderhoudsregistratie code",
                                               OnderhoudsRegRec.Klantnummer);
                OnderhoudsRegRec.SetRange(OnderhoudsRegRec."Onderhoudsregistratie code", OnderhoudRec.Code);
                OnderhoudsRegRec.SetRange(OnderhoudsRegRec.Klantnummer, OnderhoudRec.Klantnummer);
                if OnderhoudsRegRec.Find('+') then begin
                    "RegelNr." := OnderhoudsRegRec.Regelnummer + 10000;
                end else begin
                    "RegelNr." := 10000;
                end;
                OnderhoudsRegInsRec.INIT();
                OnderhoudsRegInsRec."Onderhoudsregistratie code" := OnderhoudRec.Code;
                OnderhoudsRegInsRec.Klantnummer := OnderhoudRec.Klantnummer;
                OnderhoudsRegInsRec.Regelnummer := "RegelNr.";
                OnderhoudsRegInsRec.Datum := "Date Visited";
                OnderhoudsRegInsRec.Omschrijving := Description;
                OnderhoudsRegInsRec.Gebruiker := UserId;
                OnderhoudsRegInsRec."Omschrijving 2" := Text60014;
                OnderhoudsRegInsRec.INSERT();
            end;
        end;
    end;


    procedure VerwerkenKlantvoorraden()
    var
        CheckStockRec: Record "Cust. Stock";
        "Cust.No.": Code[20];
        "Item No.": Code[20];
        "Check Date": Date;
        Quantity: Decimal;
    begin
        "Cust.No." := CopyStr(RecImportTerminal.Omschrijving, 3, 6);

        "Item No." := CopyStr(RecImportTerminal.Omschrijving, 9, 4);

        Evaluate("Check Date", CopyStr(RecImportTerminal.Omschrijving, 13, 2) + CopyStr(RecImportTerminal.Omschrijving, 15, 2) +
                              CopyStr(RecImportTerminal.Omschrijving, 17, 2));

        Evaluate(Quantity, CopyStr(RecImportTerminal.Omschrijving, 19, 2));

        if not CheckStockRec.Get("Cust.No.", "Item No.", "Check Date") then begin
            CheckStockRec.INIT();
            CheckStockRec."Cust. No." := "Cust.No.";
            CheckStockRec."Item No." := "Item No.";
            CheckStockRec."Check Date" := "Check Date";
            CheckStockRec."Quantity in stock" := Quantity;
            CheckStockRec.INSERT();
        end;
    end;
}

