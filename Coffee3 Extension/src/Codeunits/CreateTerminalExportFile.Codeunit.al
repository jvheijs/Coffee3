codeunit 50002 "CreateTerminalExportFile"
{
    // CS1.0 230218 JHE : ActieveTerminalCode een voorloop 0 gegeven, omdat deze naar de nieuwe locatiecode(voorloopnul) kijkt.
    // CS1.1 230718 BKR : BEZOEK adres ipv uit de tabel Klant
    // CS1.1 230718 BKR : KlantBetaaltermijn := '00'; toegevoed als default


    trigger OnRun()
    var
        lRecSalesSetUp: Record "Sales & Receivables Setup";
        varOutputStream: OutStream;
        lTxtVolgNummer: Text[2];
        ReadyTxt: Label 'Klaar met acties.';
        lDiaStatus: Dialog;
    begin
        Clear(AktieveArtikelenExporteren);

        CR[1] := 13;
        // Form tbv export
        if ExportForm.RUNMODAL() = ACTION::OK then begin
            // Initieel of mutatie exportbestand?
            Hulptabel50007Rec.RESET();
            Hulptabel50007Rec.SETRANGE(Volgnummer, 39);
            if Hulptabel50007Rec.FIND('-') then
                if Hulptabel50007Rec."Meenemen in export?" = true then
                    InitieelBestand := true;

            // BEGIN VIGEO BB 02-01-2006 FNT-84 Ophalen of alle artikelen geexporteerd moeten worden
            Hulptabel50007Rec.RESET();
            Hulptabel50007Rec.SETRANGE(Volgnummer, 48);
            if Hulptabel50007Rec.FIND('-') then
                if Hulptabel50007Rec."Meenemen in export?" = true then
                    AktieveArtikelenExporteren := true;
            // EINDE VIGEO BB

            // Bepaal voor welke terminal een exportbestand moet worden aangemaakt
            // en vanaf welke datum mutaties moeten worden meegenomen
            Hulptabel50007Rec.RESET();
            Hulptabel50007Rec.SETRANGE(Volgnummer, 1, 30);
            Hulptabel50007Rec.SETRANGE("Meenemen in export?", true);
            if Hulptabel50007Rec.FIND('-') then begin

                // CS1.0 <<
                lRecSalesSetUp.GET();
                lRecSalesSetUp.TESTFIELD("Name exportdirectory");
                lDiaStatus.OPEN('Bestanden worden aangemaakt #1########');
                // CS1.0 >>
                repeat
                    if Hulptabel50007Rec.Geexporteerd = false then begin
                        ActieveTerminal := Hulptabel50007Rec.Volgnummer;
                        LaatsteMutatieExportKlanten := Hulptabel50007Rec."Laatste mut-export klanten";
                        LaatsteMutatieExportArtikelen := Hulptabel50007Rec."Laatste mut-export artikelen";
                        LaatsteMutatieExportVoorraad := Hulptabel50007Rec."Laatste mut-export voorraad mu";
                        ExportBestandMaken();

                        // CS1.0 <<
                        CLEAR(varOutputStream);
                        lTxtVolgNummer := FORMAT(Hulptabel50007Rec.Volgnummer);
                        if STRLEN(lTxtVolgNummer) = 1 then
                            lTxtVolgNummer := '0' + CopyStr(lTxtVolgNummer, 1, 1);

                        // CS1.0 >>

                        Hulptabel50007Rec.Geexporteerd := true;
                        Hulptabel50007Rec2.RESET();
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 31);
                        if Hulptabel50007Rec2.FIND('-') and Hulptabel50007Rec2."Meenemen in export?" = true then
                            Hulptabel50007Rec."Laatste mut-export klanten" := TODAY;
                        Hulptabel50007Rec2.RESET();
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 32);
                        if Hulptabel50007Rec2.FIND('-') and Hulptabel50007Rec2."Meenemen in export?" = true then
                            Hulptabel50007Rec."Laatste mut-export artikelen" := TODAY;
                        Hulptabel50007Rec2.RESET();
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 34);
                        if Hulptabel50007Rec2.FIND('-') and Hulptabel50007Rec2."Meenemen in export?" = true then
                            Hulptabel50007Rec."Laatste mut-export voorraad mu" := TODAY;
                        Hulptabel50007Rec.MODIFY();
                    end;
                until Hulptabel50007Rec.NEXT() = 0;
                lDiaStatus.CLOSE();                          // CS1.0
                MESSAGE(ReadyTxt);                         // CS1.0
            end;
        end;
    end;

    var

        Hulptabel50007Rec: Record "Temp. Table Export";
        Hulptabel50007Rec2: Record "Temp. Table Export";
        ExportTerminalRec: Record "Export terminal";
        ArtikelRec: Record Item;
        ArtikelPostRec: Record "Item Ledger Entry";
        ExportTerminalRec2: Record "Export terminal";
        Hulptabel50007Rec3: Record "Temp. Table Export";
        BTWPBGRec: Record "VAT Product Posting Group";
        KlantRec: Record Customer;
        KlantenPostenRec: Record "Cust. Ledger Entry";
        StuklijstcomponentRec: Record "BOM Component";
        KlantenPosten2Rec: Record "Cust. Ledger Entry";
        OnderhoudsRegRec: Record "Maintenance Reg. Machinery";
        ArtRec: Record Item;
        VerkInstelRec: Record "Sales & Receivables Setup";
        CustMessRec: Record "Cust. Messages";
        TempHistRec: Record "Temp File History";
        CustStockRec: Record "Cust. Stock";
        SalesSetupRec: Record "Sales & Receivables Setup";
        ItemLedgRec: Record "Item Ledger Entry";
        InitieelBestand: Boolean;
        AktieveArtikelenExporteren: Boolean;
        LaatsteMutatieExportArtikelen: Date;
        LaatsteMutatieExportKlanten: Date;
        LaatsteMutatieExportVoorraad: Date;
        LaatsteVolgNummer: Integer;
        VoorraadArtikel: Code[10];
        VoorraadTeken: Text[1];
        VoorraadAantal: Integer;
        VoorraadAantalString: Text[10];
        ActieveTerminal: Integer;
        ArtikelArtikel: Code[10];
        ArtikelOmschrijving: Text[25];
        ArtikelBTWCode: Code[1];
        ArtikelVerkoopprijs: Text[15];
        ArtikelNummerMoederArtikel: Code[10];
        ArtikelFactorMoederArtikel: Code[2];
        PositieKomma: Integer;
        AchterKomma: Text[30];
        BTWCode: Text[1];
        BTWPercentage: Text[6];
        OPostenKlantnummer: Text[6];
        OPostenFactuurnummer: Text[10];
        OPostenFactuurDatum: Text[8];
        OPostenOpenstaandBedrag: Text[10];
        OPostenAantalAanmaningen: Text[2];
        KlantRayonNummer: Code[2];
        KlantRouteNummer: Code[2];
        KlantDropcode: Code[2];
        KlantKlantnummer: Text[6];
        KlantNaam: Text[30];
        KlantAdres: Text[25];
        KlantPostcode: Text[7];
        KlantPlaats: Text[23];
        KlantBetaaltermijn: Code[2];
        KlantBGNummer: Text[9];
        KlantIncasso: Text[1];
        KlantBICodeTemp: Text[2];
        KlantBICode: Text[1];
        KlantRembours: Text[1];
        KlantMalusPercentage: Text[2];
        Vertegenwoordiger: Code[2];
        ActieArtikelen: Code[12];
        Password: Code[4];
        Memotekst: Text[40];
        ActieveTerminalCode: Code[2];
        CR: Text[1];
        LtstContDat: Text[6];
        LtstContSrt: Code[1];
        Dag: Text[2];
        Maand: Text[2];
        Jaar: Text[2];
        Serienr: Text[10];
        Garantie: Code[1];
        GarantieTotDatum: Date;
        Memo1: Text[20];
        Memo2: Text[20];
        Mess1: Text[20];
        Mess2: Text[20];
        Berichtdatum: Text[6];
        Dag2: Text[2];
        Maand2: Text[2];
        Jaar2: Text[2];
        EANCode: Text[30];
        RecCounter: Integer;
        "LastItemNo.": Code[20];
        "ItemNo.": Code[4];
        CheckDate: Text[6];
        QuantityStock: Text[3];
        QuantityOrd: Text[3];
        CountedStock: Code[1];
        Dag3: Text[2];
        Maand3: Text[2];
        Jaar3: Text[2];
        ExportForm: Page "Export Terminal List";
        Text60000: Label '~o';
        Text60001: Label '~ncc';
        Text60002: Label '~nII';
        Text60003: Label '~e';
        Text60004: Label '~kM';
        Text60005: Label '~a';
        Text60006: Label '~nMM';
        Text60007: Label '~kV';
        Text60008: Label '~nVV';
        Text60009: Label '~nAA';
        Text60010: Label '~kA';
        Text60011: Label '~kT';
        Text60012: Label '~nTT';
        Text60013: Label 'A..Z';
        Text60014: Label '~kW';
        Text60015: Label '~nWW';
        Text60016: Label '~kP';
        Text60017: Label '~nPP';
        Text60018: Label '~nKK';
        Text60019: Label 'P';
        Text60020: Label 'J';
        Text60021: Label 'N';
        Text60022: Label '~kK';
        Text60023: Label '~00050305';
        Text60024: Label '~kC';
        Text60025: Label '~nCC';
        Text60026: Label '~kG';
        Text60027: Label '~nGG';
        Text60028: Label '~kX';
        Text60029: Label '~nXX';
        Text60030: Label '~kB';
        Text60031: Label '~nBB';
        Text60032: Label '~kH';
        Text60033: Label '~nHH';
        BTWIdentRec: Record "VAT Posting Setup";
        ShiptoAddress: Record "Ship-to Address";

    procedure ExportBestandMaken()
    begin
        // BESTAND LEEGMAKEN
        ExportTerminalRec.DELETEALL();

        // Commando's aan begin van exportbestand
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60001;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60023;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60002;
        ExportTerminalRec.INSERT();

        // Vertegenwoordiger
        Vertegenwoordiger := FORMAT(ActieveTerminal);
        while STRLEN(Vertegenwoordiger) < 2 do
            Vertegenwoordiger := '0' + Vertegenwoordiger;

        ActieArtikelen := '000000000000';
        while STRLEN(ActieArtikelen) < 12 do
            ActieArtikelen := ActieArtikelen + '0';
        // Password
        Password := '    ';
        // Memotekst
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 40);
        if Hulptabel50007Rec3.FIND('-') then
            Memotekst := Hulptabel50007Rec3."Omschrijving terminal";
        while STRLEN(Memotekst) < 40 do
            Memotekst := Memotekst + ' ';
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Vertegenwoordiger + ActieArtikelen + Password + Memotekst;
        ExportTerminalRec.INSERT();

        // Welke gegevens moeten meegenomen moeten worden?

        // Klanten
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 31);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then begin
            if not InitieelBestand then
                KlantMutatiesMaken
            else
                KlantAllesMaken;
        end;

        // Artikelen
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 32);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then begin
            if not InitieelBestand then
                ArtikelMutatiesMaken
            else
                ArtikelAllesMaken;
        end;

        // Sneltoetsen
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 33);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            SneltoetsenMaken;

        // Voorraad mutaties
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 34);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            VoorraadMutatiesMaken;

        // Voorraad posities
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 35);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            VoorraadPositiesMaken;

        // Openstaande posten
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 36);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            OpenstaandePostenMaken;

        // BTW-codes
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 37);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            BTWCodesMaken;

        // Contact
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 42);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            ContactMaken;

        // Garantie
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 43);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            GarantieMaken;

        // Memonw
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 44);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            MemonwMaken;

        // Bericht
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 45);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            BerichtMaken;

        // Historie
        Hulptabel50007Rec3.RESET();
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 46);
        if Hulptabel50007Rec3.FIND('-') and
           (Hulptabel50007Rec3."Meenemen in export?" = true) then
            HistorieMaken;

        // Commando's aan einde van exportbestand
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60003 + CR;
        ExportTerminalRec.INSERT();
    end;

    procedure BepaalVolgendeNummer(): Integer
    begin
        ExportTerminalRec2.RESET();
        if ExportTerminalRec2.FIND('+') then begin
            LaatsteVolgNummer := ExportTerminalRec2."Volgnr." + 1;
            exit(LaatsteVolgNummer);
        end else
            LaatsteVolgNummer := 1;
    end;

    procedure VoorraadMutatiesMaken()
    begin
        // Voorraad mutaties
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60004;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60005;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60006;
        ExportTerminalRec.INSERT();
        ArtikelRec.RESET();
        if ArtikelRec.FIND('-') then begin
            repeat
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //if NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                VoorraadAantal := 0;
                ActieveTerminalCode := FORMAT(ActieveTerminal);
                if (STRLEN(ActieveTerminalCode) = 1) then                                                   // CS1.0
                    ActieveTerminalCode := '0' + ActieveTerminalCode;                                         // CS1.0
                ArtikelPostRec.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                ArtikelPostRec.SETRANGE("Entry Type", ArtikelPostRec."Entry Type"::Transfer);
                ArtikelPostRec.SETRANGE("Item No.", ArtikelRec."No.");
                ArtikelPostRec.SETRANGE("Location Code", ActieveTerminalCode);
                ArtikelPostRec.SETRANGE("Posting Date", LaatsteMutatieExportVoorraad, TODAY + 1);
                if ArtikelPostRec.FIND('-') then begin
                    // BEGIN VIGEO BB 22-12-2005
                    //VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.",1,3);
                    VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.", 1, 4);
                    // EINDE VIGEO BB
                    repeat
                        //BEGIN ACA RB dec. bij int. optellen
                        VoorraadAantal := VoorraadAantal + ROUND(ArtikelPostRec.Quantity, 1, '=');
                    until ArtikelPostRec.NEXT() = 0;
                    if VoorraadAantal >= 0 then
                        VoorraadTeken := '0'
                    else begin
                        VoorraadTeken := '-';
                        VoorraadAantal := ABS(VoorraadAantal);
                    end;
                    VoorraadAantalString := FORMAT(VoorraadAantal);
                    // ATW BCO 240401 begin nieuw
                    PositieKomma := 0;
                    PositieKomma := STRPOS(VoorraadAantalString, ',');
                    if PositieKomma > 0 then
                        VoorraadAantalString := COPYSTR(VoorraadAantalString, 1, (PositieKomma - 1));
                    // ATW BCO 240401 eind nieuw
                    while STRLEN(VoorraadAantalString) < 3 do
                        VoorraadAantalString := '0' + VoorraadAantalString;
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := VoorraadArtikel + VoorraadTeken + VoorraadAantalString;
                    ExportTerminalRec.INSERT();
                end;
            //END;
            until ArtikelRec.NEXT() = 0;
        end;
    end;

    procedure VoorraadPositiesMaken()
    begin
        // Voorraad posities

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60007;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60008;
        ExportTerminalRec.INSERT();

        ArtikelRec.RESET();
        if ArtikelRec.FIND('-') then begin
            repeat
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //if NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                VoorraadAantal := 0;
                ActieveTerminalCode := FORMAT(ActieveTerminal);
                if (STRLEN(ActieveTerminalCode) = 1) then                                                   // CS1.0
                    ActieveTerminalCode := '0' + ActieveTerminalCode;                                         // CS1.0
                ArtikelPostRec.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                ArtikelPostRec.SETRANGE("Item No.", ArtikelRec."No.");
                ArtikelPostRec.SETRANGE("Location Code", ActieveTerminalCode);
                if ArtikelPostRec.FIND('-') then begin
                    // BEGIN VIGEO BB 22-12-2005
                    //VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.",1,3);
                    VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.", 1, 4);
                    // EINDE VIGEO BB
                    repeat
                        //BEGIN ACA RB dec. bij int. optellen
                        VoorraadAantal := VoorraadAantal + ROUND(ArtikelPostRec.Quantity, 1, '=');
                    until ArtikelPostRec.NEXT() = 0;
                    if VoorraadAantal >= 0 then
                        VoorraadTeken := '0'
                    else begin
                        VoorraadTeken := '-';
                        VoorraadAantal := ABS(VoorraadAantal);
                    end;
                    VoorraadAantalString := FORMAT(VoorraadAantal);
                    // ATW BCO 240401 begin nieuw
                    PositieKomma := 0;
                    PositieKomma := STRPOS(VoorraadAantalString, ',');
                    if PositieKomma > 0 then
                        VoorraadAantalString := COPYSTR(VoorraadAantalString, 1, (PositieKomma - 1));
                    // ATW BCO 240401 eind nieuw
                    while STRLEN(VoorraadAantalString) < 3 do
                        VoorraadAantalString := '0' + VoorraadAantalString;
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := VoorraadArtikel + VoorraadTeken + VoorraadAantalString;
                    ExportTerminalRec.INSERT();
                end;
            //END;
            until ArtikelRec.NEXT() = 0;
        end;
    end;

    procedure ArtikelMutatiesMaken()
    begin

        // Mutaties artikelen

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60009;
        ExportTerminalRec.INSERT();

        ArtikelRec.RESET();
        ArtikelRec.SETRANGE("Last Date Modified", LaatsteMutatieExportArtikelen, (TODAY + 1));
        if ArtikelRec.FIND('-') then begin
            repeat
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //if NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                ArtikelArtikel := '';
                ArtikelOmschrijving := '';
                ArtikelBTWCode := '';
                ArtikelVerkoopprijs := '';
                ArtikelNummerMoederArtikel := '';
                ArtikelFactorMoederArtikel := '';
                //BEGIN ACA RB
                //EANCode := '';
                //EINDE ACA
                ArtikelArtikel := FORMAT(ArtikelRec."No.");
                EANCode := '0000000000000';
                // BEGIN VIGEO BB 22-12-2005
                //ArtikelArtikel := COPYSTR(ArtikelArtikel,1,3);
                ArtikelArtikel := COPYSTR(ArtikelArtikel, 1, 4);
                // EINDE VIGEO BB
                while STRLEN(ArtikelArtikel) < 4 do
                    ArtikelArtikel := '0' + ArtikelArtikel;
                //VoorraadAantalString := '0' + ArtikelArtikel;
                ArtikelOmschrijving := COPYSTR(ArtikelRec.Description, 1, 25);
                while STRLEN(ArtikelOmschrijving) < 25 do
                    ArtikelOmschrijving := ArtikelOmschrijving + ' ';
                ArtikelBTWCode := ArtikelRec."VAT Prod. Posting Group";
                ArtikelVerkoopprijs := FORMAT(ROUND(ArtikelRec."Unit Price", 0.0001, '='));
                ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, 10);
                ArtikelVerkoopprijs := DELCHR(ArtikelVerkoopprijs, '=', '.');   // Punten van duizendtallen verwijderen
                PositieKomma := 0;
                AchterKomma := '';
                PositieKomma := STRPOS(ArtikelVerkoopprijs, ',');
                if PositieKomma > 0 then begin
                    AchterKomma := COPYSTR(ArtikelVerkoopprijs, PositieKomma + 1, 2);
                    while STRLEN(AchterKomma) < 2 do
                        AchterKomma := AchterKomma + '0';
                    if PositieKomma <= 5 then begin
                        ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, PositieKomma);
                        ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                        ArtikelVerkoopprijs := CONVERTSTR(ArtikelVerkoopprijs, ',', '.');
                    end else
                        ArtikelVerkoopprijs := '0000.00';
                end else begin
                    AchterKomma := '.00';
                    ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                end;
                while STRLEN(ArtikelVerkoopprijs) < 7 do
                    ArtikelVerkoopprijs := '0' + ArtikelVerkoopprijs;
                // nummer + factor moeder artikel
                StuklijstcomponentRec.RESET();
                StuklijstcomponentRec.SETRANGE("Parent Item No.", ArtikelRec."No.");
                if StuklijstcomponentRec.FIND('-') then begin
                    ArtikelNummerMoederArtikel := FORMAT(StuklijstcomponentRec."No.");
                    // BEGIN VIGEO BB 22-12-2005
                    //ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel,1,3);
                    ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel, 1, 4);
                    // EINDE VIGEO BB
                    ArtikelFactorMoederArtikel := FORMAT(StuklijstcomponentRec."Quantity per");
                    ArtikelFactorMoederArtikel := COPYSTR(ArtikelFactorMoederArtikel, 1, 2);
                    while STRLEN(ArtikelFactorMoederArtikel) < 2 do
                        ArtikelFactorMoederArtikel := '0' + ArtikelFactorMoederArtikel;
                end else begin
                    ArtikelNummerMoederArtikel := '0000';
                    ArtikelFactorMoederArtikel := '00';
                end;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := ArtikelArtikel + ArtikelOmschrijving + ArtikelBTWCode + ArtikelVerkoopprijs +
                                                  ArtikelNummerMoederArtikel + ArtikelFactorMoederArtikel + EANCode;
                ExportTerminalRec.INSERT();
            //END;
            until ArtikelRec.NEXT() = 0;
        end;
    end;

    procedure ArtikelAllesMaken()
    begin

        // Alle artikelen

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60010;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60009;
        ExportTerminalRec.INSERT();

        ArtikelRec.RESET();
        if ArtikelRec.FIND('-') then begin
            repeat
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //if NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                ArtikelArtikel := FORMAT(ArtikelRec."No.");
                // BEGIN VIGEO BB 22-12-2005
                //ArtikelArtikel := COPYSTR(ArtikelArtikel,1,3);
                ArtikelArtikel := COPYSTR(ArtikelArtikel, 1, 4);
                // EINDE VIGEO BB
                EANCode := '0000000000000';
                while STRLEN(ArtikelArtikel) < 4 do
                    ArtikelArtikel := '0' + ArtikelArtikel;
                //VoorraadAantalString := '0' + ArtikelArtikel;
                ArtikelOmschrijving := COPYSTR(ArtikelRec.Description, 1, 25);
                while STRLEN(ArtikelOmschrijving) < 25 do
                    ArtikelOmschrijving := ArtikelOmschrijving + ' ';
                ArtikelBTWCode := ArtikelRec."VAT Prod. Posting Group";
                ArtikelVerkoopprijs := FORMAT(ROUND(ArtikelRec."Unit Price", 0.0001, '='));
                ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, 10);
                ArtikelVerkoopprijs := DELCHR(ArtikelVerkoopprijs, '=', '.');            // Punten van duizendtallen verwijderen
                PositieKomma := 0;
                AchterKomma := '';
                PositieKomma := STRPOS(ArtikelVerkoopprijs, ',');
                if PositieKomma > 0 then begin
                    AchterKomma := COPYSTR(ArtikelVerkoopprijs, PositieKomma + 1, 2);
                    while STRLEN(AchterKomma) < 2 do
                        AchterKomma := AchterKomma + '0';
                    if PositieKomma <= 5 then begin
                        ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, PositieKomma);
                        ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                        ArtikelVerkoopprijs := CONVERTSTR(ArtikelVerkoopprijs, ',', '.');
                    end else
                        ArtikelVerkoopprijs := '0000.00';
                end else begin
                    AchterKomma := '.00';
                    ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                end;
                while STRLEN(ArtikelVerkoopprijs) < 7 do
                    ArtikelVerkoopprijs := '0' + ArtikelVerkoopprijs;
                // nummer + factor moeder artikel
                StuklijstcomponentRec.RESET();
                StuklijstcomponentRec.SETRANGE("Parent Item No.", ArtikelRec."No.");
                if StuklijstcomponentRec.FIND('-') then begin
                    ArtikelNummerMoederArtikel := FORMAT(StuklijstcomponentRec."No.");
                    // BEGIN VIGEO BB 22-12-2005
                    //ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel,1,3);
                    ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel, 1, 4);
                    // EINDE VIGEO BB
                    ArtikelFactorMoederArtikel := FORMAT(StuklijstcomponentRec."Quantity per");
                    ArtikelFactorMoederArtikel := COPYSTR(ArtikelFactorMoederArtikel, 1, 2);
                    while STRLEN(ArtikelFactorMoederArtikel) < 2 do
                        ArtikelFactorMoederArtikel := '0' + ArtikelFactorMoederArtikel;
                end else begin
                    ArtikelNummerMoederArtikel := '0000';
                    ArtikelFactorMoederArtikel := '00';
                end;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := ArtikelArtikel + ArtikelOmschrijving + ArtikelBTWCode + ArtikelVerkoopprijs +
                                                  ArtikelNummerMoederArtikel + ArtikelFactorMoederArtikel + EANCode;
                ExportTerminalRec.INSERT();
            //END;
            until ArtikelRec.NEXT() = 0;
        end;
    end;

    procedure SneltoetsenMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60011;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60012;
        ExportTerminalRec.INSERT();
    end;

    procedure BTWCodesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60014;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60015;
        ExportTerminalRec.INSERT();

        BTWPBGRec.RESET();
        if BTWPBGRec.FIND('-') then begin
            repeat
                BTWIdentRec.RESET();
                BTWIdentRec.SETRANGE("VAT Identifier", BTWPBGRec.Code);
                if BTWIdentRec.FINDFIRST() then begin
                    BTWCode := COPYSTR(BTWPBGRec.Code, 1, 1);
                    BTWPercentage := FORMAT(FORMAT(BTWIdentRec."VAT %"));
                    PositieKomma := STRPOS(FORMAT(BTWIdentRec."VAT %"), ',');
                    if PositieKomma > 0 then begin
                        AchterKomma := SELECTSTR(2, BTWPercentage);
                        while STRLEN(AchterKomma) < 3 do
                            AchterKomma := AchterKomma + '0';
                        BTWPercentage := COPYSTR(BTWPercentage, 1, PositieKomma);
                        BTWPercentage := BTWPercentage + AchterKomma;
                        BTWPercentage := CONVERTSTR(BTWPercentage, ',', '.');
                        while STRLEN(BTWPercentage) < 6 do
                            BTWPercentage := '0' + BTWPercentage;
                    end else begin
                        if STRLEN(BTWPercentage) = 1 then
                            BTWPercentage := '0' + BTWPercentage + '.000';
                        // ATW 050401 begin nieuw
                        if STRLEN(BTWPercentage) = 2 then
                            BTWPercentage := BTWPercentage + '.000';
                        // ATW 050401 eind nieuw
                    end;
                end;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := BTWCode + BTWPercentage;
                ExportTerminalRec.INSERT();
            until BTWPBGRec.NEXT() = 0;
        end;
    end;

    procedure OpenstaandePostenMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60016;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60017;
        ExportTerminalRec.INSERT();


        KlantRec.RESET();
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                KlantenPostenRec.RESET();
                KlantenPostenRec.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                KlantenPostenRec.SETRANGE("Customer No.", KlantRec."No.");
                KlantenPostenRec.SETRANGE(Open, true);
                KlantenPostenRec.SETRANGE(Positive, true);
                KlantenPostenRec.SETRANGE(KlantenPostenRec."Document Type", KlantenPostenRec."Document Type"::Invoice);
                if KlantenPostenRec.FIND('-') then begin
                    repeat
                        OPostenKlantnummer := FORMAT(KlantenPostenRec."Customer No.");
                        while STRLEN(OPostenKlantnummer) < 6 do
                            OPostenKlantnummer := '0' + OPostenKlantnummer;
                        OPostenFactuurnummer := FORMAT(KlantenPostenRec."Document No.");
                        //BEGIN ACA RB Als factuurnummer > 7 dan afkorten op de laatste 7 pos
                        if STRLEN(OPostenFactuurnummer) > 7 then
                            OPostenFactuurnummer := COPYSTR(OPostenFactuurnummer, STRLEN(OPostenFactuurnummer) - 6, STRLEN(OPostenFactuurnummer));
                        //EINDE ACA
                        while STRLEN(OPostenFactuurnummer) < 7 do
                            OPostenFactuurnummer := '0' + OPostenFactuurnummer;
                        OPostenFactuurDatum := FORMAT(KlantenPostenRec."Document Date");
                        OPostenFactuurDatum := COPYSTR(OPostenFactuurDatum, 1, 2) + COPYSTR(OPostenFactuurDatum, 4, 2) +
                                               COPYSTR(OPostenFactuurDatum, 7, 2);
                        OPostenOpenstaandBedrag := FORMAT(KlantenPostenRec."Remaining Amount");
                        OPostenOpenstaandBedrag := DELCHR(OPostenOpenstaandBedrag, '=', '.');
                        PositieKomma := 0;
                        AchterKomma := '';
                        PositieKomma := STRPOS(OPostenOpenstaandBedrag, ',');
                        if PositieKomma > 0 then begin
                            AchterKomma := COPYSTR(OPostenOpenstaandBedrag, (PositieKomma + 1), 2);
                            /*         AchterKomma := SELECTSTR(2,OPostenOpenstaandBedrag);
                                      AchterKomma := COPYSTR(AchterKomma,1,2); */
                            while STRLEN(AchterKomma) < 2 do
                                AchterKomma := AchterKomma + '0';
                            if PositieKomma <= 8 then begin
                                OPostenOpenstaandBedrag := COPYSTR(OPostenOpenstaandBedrag, 1, PositieKomma);
                                OPostenOpenstaandBedrag := OPostenOpenstaandBedrag + AchterKomma;
                                OPostenOpenstaandBedrag := CONVERTSTR(OPostenOpenstaandBedrag, ',', '.');
                            end else
                                OPostenOpenstaandBedrag := '0000000.00';
                        end else begin
                            AchterKomma := '.00';
                            OPostenOpenstaandBedrag := COPYSTR(OPostenOpenstaandBedrag, 1, 7) + AchterKomma;
                        end;
                        while STRLEN(OPostenOpenstaandBedrag) < 10 do
                            OPostenOpenstaandBedrag := '0' + OPostenOpenstaandBedrag;
                        OPostenAantalAanmaningen := '00';
                        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                        ExportTerminalRec.Omschrijving := OPostenKlantnummer + OPostenFactuurnummer + OPostenFactuurDatum +
                                                          OPostenOpenstaandBedrag + OPostenAantalAanmaningen;
                        ExportTerminalRec.INSERT();
                    until KlantenPostenRec.NEXT() = 0;
                end;
            until KlantRec.NEXT() = 0;
        end;

    end;

    procedure KlantMutatiesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60018;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        KlantRec.SETRANGE(KlantRec."Last Date Modified", LaatsteMutatieExportKlanten, (TODAY + 1));
        if KlantRec.FIND('-') then begin
            repeat


                KlantRayonNummer := FORMAT(KlantRec.Rayon);
                while STRLEN(KlantRayonNummer) < 2 do
                    KlantRayonNummer := '0' + KlantRayonNummer;
                KlantRouteNummer := FORMAT(KlantRec.Routenummer);
                while STRLEN(KlantRouteNummer) < 2 do
                    KlantRouteNummer := '0' + KlantRouteNummer;
                KlantDropcode := FORMAT(KlantRec.Dropcode);
                while STRLEN(KlantDropcode) < 2 do
                    KlantDropcode := '0' + KlantDropcode;
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;
                KlantNaam := COPYSTR(KlantRec.Name, 1, 30);
                while STRLEN(KlantNaam) < 30 do
                    KlantNaam := KlantNaam + ' ';
                // Bezoek adres ophalen
                ShiptoAddress.SETFILTER("Customer No.", KlantRec."No.");
                ShiptoAddress.SETFILTER(Code, 'BEZOEK');
                if ShiptoAddress.FINDFIRST() then begin
                    KlantAdres := COPYSTR(ShiptoAddress.Address, 1, 25);
                    while STRLEN(KlantAdres) < 25 do
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(ShiptoAddress."Post Code", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    while STRLEN(KlantPostcode) < 6 do
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(ShiptoAddress.City, 1, 23);
                end else begin
                    KlantAdres := COPYSTR(KlantRec.Bezoekadres, 1, 25);
                    while STRLEN(KlantAdres) < 25 do
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(KlantRec."Postcode bezoekadres", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    while STRLEN(KlantPostcode) < 6 do
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(KlantRec."Plaats bezoekadres", 1, 23);
                end;
                while STRLEN(KlantPlaats) < 23 do
                    KlantPlaats := KlantPlaats + ' ';
                KlantBetaaltermijn := '00'; // CS1.1 BKR
                case true of
                    KlantRec."Payment Terms Code" = '01':
                        begin
                            KlantBetaaltermijn := '00';
                        end;
                    KlantRec."Payment Terms Code" = '02':
                        begin
                            KlantBetaaltermijn := '08';
                        end;
                    KlantRec."Payment Terms Code" = '03':
                        begin
                            KlantBetaaltermijn := '35';
                        end;
                    KlantRec."Payment Terms Code" = '04':
                        begin
                            KlantBetaaltermijn := '00';
                        end;
                    KlantRec."Payment Terms Code" = '05':
                        begin
                            KlantBetaaltermijn := '45';
                        end;
                end;
                KlantBGNummer := COPYSTR(KlantRec."Preferred Bank Account Code", 1, 9);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', Text60019);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', ' ');
                while STRLEN(KlantBGNummer) < 9 do
                    KlantBGNummer := '0' + KlantBGNummer;
                //if KlantRec."Incasso J/N" = TRUE THEN
                //  KlantIncasso := Text60020
                //ELSE
                KlantIncasso := Text60021;
                if (KlantRec."Payment Method Code" = '0') or (KlantRec."Payment Method Code" = '') then
                    KlantBICode := '0'
                else begin
                    KlantBICodeTemp := FORMAT(KlantRec."Payment Method Code");
                    KlantBICode := COPYSTR(KlantBICodeTemp, 2, 1);
                end;
                //if KlantRec."Rembours J/N" = TRUE THEN
                //  KlantRembours := Text60020
                //ELSE
                KlantRembours := Text60021;
                KlantMalusPercentage := '';
                KlantMalusPercentage := COPYSTR(KlantMalusPercentage, 1, 2);
                while STRLEN(KlantMalusPercentage) < 2 do
                    KlantMalusPercentage := '0' + KlantMalusPercentage;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantRayonNummer + KlantRouteNummer + KlantDropcode +
                                                  KlantKlantnummer + KlantNaam + KlantAdres + KlantPostcode +
                                                KlantPlaats + KlantBetaaltermijn + KlantBGNummer +
                                                KlantIncasso + KlantBICode + KlantRembours + KlantMalusPercentage;
                ExportTerminalRec.INSERT();
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure KlantAllesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60022;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60018;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                KlantRayonNummer := FORMAT(KlantRec.Rayon);
                while STRLEN(KlantRayonNummer) < 2 do
                    KlantRayonNummer := '0' + KlantRayonNummer;
                KlantRouteNummer := FORMAT(KlantRec.Routenummer);
                while STRLEN(KlantRouteNummer) < 2 do
                    KlantRouteNummer := '0' + KlantRouteNummer;
                KlantDropcode := FORMAT(KlantRec.Dropcode);
                while STRLEN(KlantDropcode) < 2 do
                    KlantDropcode := '0' + KlantDropcode;
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;
                KlantNaam := COPYSTR(KlantRec.Name, 1, 30);
                while STRLEN(KlantNaam) < 30 do
                    KlantNaam := KlantNaam + ' ';
                // Bezoek adres ophalen
                ShiptoAddress.SETFILTER("Customer No.", KlantRec."No.");
                ShiptoAddress.SETFILTER(Code, 'BEZOEK');
                if ShiptoAddress.FINDFIRST() then begin
                    KlantAdres := COPYSTR(ShiptoAddress.Address, 1, 25);
                    while STRLEN(KlantAdres) < 25 do
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(ShiptoAddress."Post Code", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    while STRLEN(KlantPostcode) < 6 do
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(ShiptoAddress.City, 1, 23);
                end else begin
                    KlantAdres := COPYSTR(KlantRec.Bezoekadres, 1, 25);
                    while STRLEN(KlantAdres) < 25 do
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(KlantRec."Postcode bezoekadres", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    while STRLEN(KlantPostcode) < 6 do
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(KlantRec."Plaats bezoekadres", 1, 23);
                end;
                while STRLEN(KlantPlaats) < 23 do
                    KlantPlaats := KlantPlaats + ' ';
                case true of
                    KlantRec."Payment Terms Code" = '01':
                        begin
                            KlantBetaaltermijn := '00';
                        end;
                    KlantRec."Payment Terms Code" = '02':
                        begin
                            KlantBetaaltermijn := '08';
                        end;
                    KlantRec."Payment Terms Code" = '03':
                        begin
                            KlantBetaaltermijn := '35';
                        end;
                    KlantRec."Payment Terms Code" = '04':
                        begin
                            KlantBetaaltermijn := '00';
                        end;
                    KlantRec."Payment Terms Code" = '05':
                        begin
                            KlantBetaaltermijn := '45';
                        end;
                end;
                KlantBGNummer := COPYSTR(KlantRec."Preferred Bank Account Code", 1, 9);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', Text60019);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', ' ');
                while STRLEN(KlantBGNummer) < 9 do
                    KlantBGNummer := '0' + KlantBGNummer;
                //if KlantRec."Incasso J/N" = TRUE THEN
                //  KlantIncasso := Text60020
                //ELSE
                KlantIncasso := Text60021;
                if (KlantRec."Payment Method Code" = '0') or (KlantRec."Payment Method Code" = '') then
                    KlantBICode := '0'
                else begin
                    KlantBICodeTemp := FORMAT(KlantRec."Payment Method Code");
                    KlantBICode := COPYSTR(KlantBICodeTemp, 2, 1);
                end;
                //if KlantRec."Rembours J/N" = TRUE THEN
                //  KlantRembours := Text60020
                //ELSE
                KlantRembours := Text60021;
                KlantMalusPercentage := '';
                KlantMalusPercentage := COPYSTR(KlantMalusPercentage, 1, 2);
                while STRLEN(KlantMalusPercentage) < 2 do
                    KlantMalusPercentage := '0' + KlantMalusPercentage;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantRayonNummer + KlantRouteNummer + KlantDropcode +
                                                  KlantKlantnummer + KlantNaam + KlantAdres + KlantPostcode +
                                                  KlantPlaats + KlantBetaaltermijn + KlantBGNummer +
                                                  KlantIncasso + KlantBICode + KlantRembours + KlantMalusPercentage;
                ExportTerminalRec.INSERT();
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure ContactMaken()
    begin
        //ContactMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60024;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60025;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Laatste contactdatum en contactsoort
                KlantenPosten2Rec.RESET();
                KlantenPosten2Rec.SETCURRENTKEY(KlantenPosten2Rec."Customer No.", KlantenPosten2Rec."Document Type");
                KlantenPosten2Rec.SETRANGE(KlantenPosten2Rec."Customer No.", KlantRec."No.");
                KlantenPosten2Rec.SETFILTER(KlantenPosten2Rec."Document Type", '%1|%2', KlantenPosten2Rec."Document Type"::"Credit Memo",
                                                                                      KlantenPosten2Rec."Document Type"::Invoice);
                if KlantenPosten2Rec.FIND('+') then begin
                    LtstContDat := '000000';
                    LtstContSrt := '0';
                    Dag := '';
                    Maand := '';
                    Jaar := '';
                    Dag := FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 1));
                    if STRLEN(Dag) < 2 then
                        Dag := '0' + Dag;
                    Maand := FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 2));
                    if STRLEN(Maand) < 2 then
                        Maand := '0' + Maand;
                    Jaar := COPYSTR(FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 3)), 3, 2);
                    //BEGIN VIGEO RB
                    //LtstContDat := Dag + Maand + Jaar;
                    LtstContDat := Jaar + Maand + Dag;
                    //EINDE VIGEO
                    if STRLEN(KlantenPosten2Rec."Document No.") < 7 then
                        LtstContSrt := 'S'
                    else begin
                        case COPYSTR(KlantenPosten2Rec."Document No.", 1, 2) of
                            '01':
                                LtstContSrt := 'S';
                            '02':
                                LtstContSrt := 'S';
                            '03':
                                LtstContSrt := 'S';
                            '04':
                                LtstContSrt := 'S';
                            '05':
                                LtstContSrt := 'S';
                            '06':
                                LtstContSrt := 'S';
                            '07':
                                LtstContSrt := 'S';
                            '08':
                                LtstContSrt := 'S';
                            '09':
                                LtstContSrt := 'S';
                            '10':
                                LtstContSrt := 'S';
                            '11':
                                LtstContSrt := 'S';
                            '12':
                                LtstContSrt := 'S';
                            '13':
                                LtstContSrt := 'S';
                            '14':
                                LtstContSrt := 'S';
                            '15':
                                LtstContSrt := 'S';
                            '16':
                                LtstContSrt := 'S';
                            '40':
                                LtstContSrt := 'P';
                            '41':
                                LtstContSrt := 'P';
                            '60':
                                LtstContSrt := 'S';
                        end;
                        if COPYSTR(KlantenPosten2Rec."Document No.", 1, 1) = '8' then
                            LtstContSrt := 'A';
                    end;
                end;

                //Wegschrijven naar export
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantKlantnummer + LtstContDat + LtstContSrt;
                ExportTerminalRec.INSERT();
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure GarantieMaken()
    begin
        //GarantieMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60026;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60027;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Serienummer en garantie
                OnderhoudsRegRec.RESET();
                OnderhoudsRegRec.SETCURRENTKEY(OnderhoudsRegRec.Klantnummer, OnderhoudsRegRec.Actief);
                OnderhoudsRegRec.SETRANGE(OnderhoudsRegRec.Klantnummer, KlantRec."No.");
                OnderhoudsRegRec.SETRANGE(OnderhoudsRegRec.Actief, true);
                if OnderhoudsRegRec.FIND('-') then begin
                    repeat
                        Serienr := '0000000000';
                        GarantieTotDatum := 0D;
                        Garantie := '0';
                        Serienr := OnderhoudsRegRec.Serienummer;
                        while STRLEN(Serienr) < 10 do
                            Serienr := Serienr + ' ';
                        if ArtRec.GET(OnderhoudsRegRec."Type apparaat") then;
                        //GarantieTotDatum := CALCDATE(ArtRec.Garantieperiode,OnderhoudsRegRec.Opvoerdatum);
                        //if GarantieTotDatum < WORKDATE() THEN
                        Garantie := 'N';
                        //ELSE
                        //  Garantie := 'J';

                        //Wegschrijven naar export
                        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                        ExportTerminalRec.Omschrijving := KlantKlantnummer + Serienr + Garantie;
                        ExportTerminalRec.INSERT();
                    until OnderhoudsRegRec.NEXT() = 0;
                end;
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure MemonwMaken()
    begin
        //MemonwMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60028;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60029;
        ExportTerminalRec.INSERT();

        VerkInstelRec.GET;
        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Memo's vullen
                Memo1 := '';
                Memo2 := '';

                //if VerkInstelRec."General Memo" <> '' THEN BEGIN
                //  Memo1 := VerkInstelRec."General Memo";
                //  Memo2 := KlantRec."Cust.Memo1";
                //END ELSE BEGIN
                Memo1 := KlantRec."Cust.Memo1";
                Memo2 := KlantRec."Cust.Memo2";
                //END;
                while STRLEN(Memo1) < 20 do
                    Memo1 := Memo1 + ' ';
                while STRLEN(Memo2) < 20 do
                    Memo2 := Memo2 + ' ';

                //Wegschrijven naar export
                if (Memo1 <> '                    ') or (Memo2 <> '                    ') then begin
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := KlantKlantnummer + Memo1 + Memo2;
                    ExportTerminalRec.INSERT();
                end;
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure BerichtMaken()
    begin
        //BerichtMaken
        //6126 (25-09-06 RB) BEGIN Uitslashen ~KB regel
        //ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        //ExportTerminalRec.Omschrijving := Text60030;
        //ExportTerminalRec.INSERT();
        //6126 (25-09-06 RB) END
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60031;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Klantberichten
                CustMessRec.RESET();
                //BEGN VIGEO RB
                //CustMessRec.SETCURRENTKEY(CustMessRec."Customer No.",CustMessRec."Confirm Date");
                CustMessRec.SETCURRENTKEY(CustMessRec."Customer No.", CustMessRec."To Send");
                //EINDE VIGEO
                CustMessRec.SETRANGE(CustMessRec."Customer No.", KlantRec."No.");
                //BEGIN VIGEO RB
                //CustMessRec.SETFILTER(CustMessRec."Confirm Date",'%1',0D);
                CustMessRec.SETFILTER(CustMessRec."To Send", '%1', true);
                //EINDE VIGEO
                if CustMessRec.FIND('-') then begin
                    repeat
                        Mess1 := '';
                        Mess2 := '';
                        Berichtdatum := '';
                        Dag2 := '';
                        Maand2 := '';
                        Jaar2 := '';
                        Mess1 := CustMessRec."Cust. Message 1";
                        while STRLEN(Mess1) < 20 do
                            Mess1 := Mess1 + ' ';
                        Mess2 := CustMessRec."Cust. Message 2";
                        while STRLEN(Mess2) < 20 do
                            Mess2 := Mess2 + ' ';
                        Dag2 := FORMAT(DATE2DMY(CustMessRec."Message Date", 1));
                        if STRLEN(Dag2) < 2 then
                            Dag2 := '0' + Dag2;
                        Maand2 := FORMAT(DATE2DMY(CustMessRec."Message Date", 2));
                        if STRLEN(Maand2) < 2 then
                            Maand2 := '0' + Maand2;
                        Jaar2 := COPYSTR(FORMAT(DATE2DMY(CustMessRec."Message Date", 3)), 3, 2);
                        //BEGIN VIGEO RB
                        //Berichtdatum := Dag2 + Maand2 + Jaar2;
                        Berichtdatum := Jaar2 + Maand2 + Dag2;
                        //EINDE VIGEO

                        //Wegschrijven naar export
                        if (Mess1 <> '                    ') or (Mess2 <> '                    ') then begin
                            ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                            ExportTerminalRec.Omschrijving := KlantKlantnummer + Berichtdatum + Mess1 + Mess2;
                            ExportTerminalRec.INSERT();
                        end;

                        //Veld in cust. message bijwerken dat deze message verzonden is
                        CustMessRec."To Send" := false;
                        CustMessRec.MODIFY();
                    until CustMessRec.NEXT() = 0;
                end;
            until KlantRec.NEXT() = 0;
        end;
    end;

    procedure HistorieMaken()
    var
        ItemRecLO: Record Item;
    begin
        //HistorieMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60032;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT();
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60033;
        ExportTerminalRec.INSERT();

        KlantRec.RESET();
        KlantRec.SETCURRENTKEY(Rayon, "No.", Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        if KlantRec.FIND('-') then begin
            repeat
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                while STRLEN(KlantKlantnummer) < 6 do
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Leegmaken van de hulptabel
                TempHistRec.DELETEALL();

                //Vullen van de hulptabel
                //Doorlopen Voorraadopnamen
                SalesSetupRec.GET();
                CustStockRec.SETCURRENTKEY(CustStockRec."Cust. No.", CustStockRec."Item No.",
                                           CustStockRec."Check Date");
                CustStockRec.SETRANGE(CustStockRec."Cust. No.", KlantRec."No.");
                CustStockRec.SETFILTER(CustStockRec."Check Date", '%1..%2', CALCDATE(SalesSetupRec."Max. Historie Time", WORKDATE()), WORKDATE());
                if CustStockRec.FIND('-') then begin
                    repeat
                        TempHistRec.INIT();
                        TempHistRec."Cust. No." := CustStockRec."Cust. No.";
                        TempHistRec."Item No." := CustStockRec."Item No.";
                        TempHistRec."Date stock/ordered" := CustStockRec."Check Date";
                        TempHistRec."Quantity Stock" := CustStockRec."Quantity in stock";
                        TempHistRec.Counted := true;
                        TempHistRec.INSERT();
                    until CustStockRec.NEXT() = 0;
                end;

                //Doorlopen artikelposten
                ItemLedgRec.SETCURRENTKEY(ItemLedgRec."Source Type", ItemLedgRec."Source No.",
                                          ItemLedgRec."Entry Type", ItemLedgRec."Posting Date");
                ItemLedgRec.SETRANGE(ItemLedgRec."Source Type", ItemLedgRec."Source Type"::Customer);
                ItemLedgRec.SETRANGE(ItemLedgRec."Source No.", KlantRec."No.");
                ItemLedgRec.SETRANGE(ItemLedgRec."Entry Type", ItemLedgRec."Entry Type"::Sale);
                ItemLedgRec.SETFILTER(ItemLedgRec."Posting Date", '%1..%2', CALCDATE(SalesSetupRec."Max. Historie Time", WORKDATE()), WORKDATE());
                if ItemLedgRec.FIND('-') then begin
                    repeat
                        if not TempHistRec.GET(ItemLedgRec."Source No.", ItemLedgRec."Item No.", ItemLedgRec."Posting Date") then begin
                            TempHistRec.INIT();
                            TempHistRec."Cust. No." := ItemLedgRec."Source No.";
                            TempHistRec."Item No." := ItemLedgRec."Item No.";
                            TempHistRec."Date stock/ordered" := ItemLedgRec."Posting Date";
                            TempHistRec."Quantity Ordered" := ABS(ItemLedgRec.Quantity);
                            TempHistRec.INSERT();
                        end else begin
                            TempHistRec."Quantity Ordered" := TempHistRec."Quantity Ordered" + ABS(ItemLedgRec.Quantity);
                            TempHistRec.MODIFY();
                        end;
                    until ItemLedgRec.NEXT() = 0;
                end;

                TempHistRec.RESET();
                TempHistRec.SETCURRENTKEY(TempHistRec."Cust. No.", TempHistRec."Item No.", TempHistRec."Date stock/ordered");
                TempHistRec.ASCENDING(false);

                RecCounter := 1;
                "LastItemNo." := '';

                if TempHistRec.FIND('-') then begin
                    repeat
                        if ItemRecLO.GET(TempHistRec."Item No.") then begin
                            // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                            //if NOT((AktieveArtikelenExporteren = TRUE) AND (ItemRecLO."Export Item" = FALSE)) THEN BEGIN
                            if (ItemRecLO."Export Item" = true) then begin
                                if TempHistRec."Item No." = "LastItemNo." then
                                    RecCounter := RecCounter + 1
                                else
                                    RecCounter := 1;

                                if RecCounter <= 3 then begin
                                    "ItemNo." := '';
                                    CheckDate := '';
                                    Dag3 := '';
                                    Maand3 := '';
                                    Jaar3 := '';
                                    QuantityStock := '';
                                    QuantityOrd := '';

                                    //Wegschrijven naar export
                                    // BEGIN VIGEO BB 22-12-2005
                                    //"ItemNo." := COPYSTR(TempHistRec."Item No.",1,3);
                                    "ItemNo." := COPYSTR(TempHistRec."Item No.", 1, 4);
                                    // EINDE VIGEO BB

                                    Dag3 := FORMAT(DATE2DMY(TempHistRec."Date stock/ordered", 1));
                                    if STRLEN(Dag3) < 2 then
                                        Dag3 := '0' + Dag3;
                                    Maand3 := FORMAT(DATE2DMY(TempHistRec."Date stock/ordered", 2));
                                    if STRLEN(Maand3) < 2 then
                                        Maand3 := '0' + Maand3;
                                    Jaar3 := COPYSTR(FORMAT(DATE2DMY(TempHistRec."Date stock/ordered", 3)), 3, 2);
                                    //BEGIN VIGEO RB
                                    //CheckDate := Dag3 + Maand3 + Jaar3;
                                    CheckDate := Jaar3 + Maand3 + Dag3;
                                    //EINDE VIGEO

                                    QuantityOrd := FORMAT(TempHistRec."Quantity Ordered");
                                    while STRLEN(QuantityOrd) < 3 do
                                        QuantityOrd := '0' + QuantityOrd;
                                    QuantityStock := FORMAT(TempHistRec."Quantity Stock");
                                    while STRLEN(QuantityStock) < 3 do
                                        QuantityStock := '0' + QuantityStock;

                                    if TempHistRec.Counted = true then
                                        CountedStock := 'J'
                                    else
                                        CountedStock := 'N';

                                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                                    ExportTerminalRec.Omschrijving := KlantKlantnummer + "ItemNo." + CheckDate + QuantityStock + QuantityOrd +
                        CountedStock;
                                    ExportTerminalRec.INSERT();
                                end;

                                "LastItemNo." := TempHistRec."Item No.";
                            end;
                        end;
                    until TempHistRec.NEXT() = 0;
                end;
            until KlantRec.NEXT() = 0;
        end;
    end;
}

