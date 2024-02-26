codeunit 50002 "Create Terminal Export File"
{
    // CS1.0 230218 JHE : ActieveTerminalCode een voorloop 0 gegeven, omdat deze naar de nieuwe locatiecode(voorloopnul) kijkt.
    // CS1.1 230718 BKR : BEZOEK adres ipv uit de tabel Klant
    // CS1.1 230718 BKR : KlantBetaaltermijn := '00'; toegevoed als default


    trigger OnRun()
    var
        lFileXML: File;
        varOutputStream: OutStream;
        lRecSalesSetUp: Record "Sales & Receivables Setup";
        lTxtVolgNummer: Text[2];
        TxtReady: Label 'Klaar met acties.';
        lDiaStatus: Dialog;
    begin

        CR[1] := 13;
        // Form tbv export
        IF ExportForm.RUNMODAL = ACTION::OK THEN BEGIN
            // Initieel of mutatie exportbestand?
            Hulptabel50007Rec.RESET;
            Hulptabel50007Rec.SETRANGE(Volgnummer, 39);
            IF Hulptabel50007Rec.FIND('-') THEN BEGIN
                IF Hulptabel50007Rec."Meenemen in export?" = TRUE THEN
                    InitieelBestand := TRUE;
            END;

            // BEGIN VIGEO BB 02-01-2006 FNT-84 Ophalen of alle artikelen geexporteerd moeten worden
            Hulptabel50007Rec.RESET;
            Hulptabel50007Rec.SETRANGE(Volgnummer, 48);
            IF Hulptabel50007Rec.FIND('-') THEN BEGIN
                IF Hulptabel50007Rec."Meenemen in export?" = TRUE THEN BEGIN
                    AktieveArtikelenExporteren := TRUE;
                END;
            END;
            // EINDE VIGEO BB

            // Bepaal voor welke terminal een exportbestand moet worden aangemaakt
            // en vanaf welke datum mutaties moeten worden meegenomen
            Hulptabel50007Rec.RESET;
            Hulptabel50007Rec.SETRANGE(Volgnummer, 1, 30);
            Hulptabel50007Rec.SETRANGE("Meenemen in export?", TRUE);
            IF Hulptabel50007Rec.FIND('-') THEN BEGIN

                // CS1.0 <<
                lRecSalesSetUp.GET();
                lRecSalesSetUp.TESTFIELD("Name exportdirectory");
                lDiaStatus.OPEN('Bestanden worden aangemaakt #1########');
                // CS1.0 >>
                REPEAT
                    IF Hulptabel50007Rec.Geexporteerd = FALSE THEN BEGIN
                        ActieveTerminal := Hulptabel50007Rec.Volgnummer;
                        LaatsteMutatieExportKlanten := Hulptabel50007Rec."Laatste mut-export klanten";
                        LaatsteMutatieExportArtikelen := Hulptabel50007Rec."Laatste mut-export artikelen";
                        LaatsteMutatieExportVoorraad := Hulptabel50007Rec."Laatste mut-export voorraad mu";
                        ExportBestandMaken;

                        // CS1.0 <<
                        CLEAR(varOutputStream);
                        lTxtVolgNummer := FORMAT(Hulptabel50007Rec.Volgnummer);
                        IF STRLEN(lTxtVolgNummer) = 1 THEN
                            lTxtVolgNummer := '0' + lTxtVolgNummer;

                        // CS1.0 >>

                        Hulptabel50007Rec.Geexporteerd := TRUE;
                        Hulptabel50007Rec2.RESET;
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 31);
                        IF Hulptabel50007Rec2.FIND('-') AND Hulptabel50007Rec2."Meenemen in export?" = TRUE THEN
                            Hulptabel50007Rec."Laatste mut-export klanten" := TODAY;
                        Hulptabel50007Rec2.RESET;
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 32);
                        IF Hulptabel50007Rec2.FIND('-') AND Hulptabel50007Rec2."Meenemen in export?" = TRUE THEN
                            Hulptabel50007Rec."Laatste mut-export artikelen" := TODAY;
                        Hulptabel50007Rec2.RESET;
                        Hulptabel50007Rec2.SETRANGE(Volgnummer, 34);
                        IF Hulptabel50007Rec2.FIND('-') AND Hulptabel50007Rec2."Meenemen in export?" = TRUE THEN
                            Hulptabel50007Rec."Laatste mut-export voorraad mu" := TODAY;
                        Hulptabel50007Rec.MODIFY;
                    END;
                UNTIL Hulptabel50007Rec.NEXT = 0;
                lDiaStatus.CLOSE;                          // CS1.0
                MESSAGE(TxtReady);                         // CS1.0
            END;
        END;
    end;

    var
        ExportForm: Page "Export Terminal List";
        Hulptabel50007Rec: Record "Temp. Table Export";
        Hulptabel50007Rec2: Record "Temp. Table Export";
        InitieelBestand: Boolean;
        AktieveArtikelenExporteren: Boolean;
        LaatsteMutatieExportArtikelen: Date;
        LaatsteMutatieExportKlanten: Date;
        LaatsteMutatieExportVoorraad: Date;
        ExportTerminalRec: Record "Export terminal";
        LaatsteVolgNummer: Integer;
        ArtikelRec: Record Item;
        ArtikelPostRec: Record "Item Ledger Entry";
        VoorraadArtikel: Code[10];
        VoorraadTeken: Text[1];
        VoorraadAantal: Integer;
        VoorraadAantalString: Text[10];
        ActieveTerminal: Integer;
        ExportTerminalRec2: Record "Export terminal";
        Hulptabel50007Rec3: Record "Temp. Table Export";
        ArtikelArtikel: Code[10];
        ArtikelOmschrijving: Text[25];
        ArtikelBTWCode: Code[1];
        ArtikelVerkoopprijs: Text[15];
        ArtikelNummerMoederArtikel: Code[10];
        ArtikelFactorMoederArtikel: Code[2];
        PositieKomma: Integer;
        AchterKomma: Text[30];
        BTWPBGRec: Record "VAT Product Posting Group";
        BTWCode: Text[1];
        BTWPercentage: Text[6];
        OPostenKlantnummer: Text[6];
        OPostenFactuurnummer: Text[10];
        OPostenFactuurDatum: Text[8];
        OPostenOpenstaandBedrag: Text[10];
        OPostenAantalAanmaningen: Text[2];
        KlantRec: Record Customer;
        KlantenPostenRec: Record "Cust. Ledger Entry";
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
        StuklijstcomponentRec: Record "BOM Component";
        ActieveTerminalCode: Code[2];
        CR: Text[1];
        KlantenPosten2Rec: Record "Cust. Ledger Entry";
        LtstContDat: Text[6];
        LtstContSrt: Code[1];
        Dag: Text[2];
        Maand: Text[2];
        Jaar: Text[2];
        OnderhoudsRegRec: Record "Maintenance Reg. Machinery";
        Serienr: Text[10];
        Garantie: Code[1];
        ArtRec: Record Item;
        GarantieTotDatum: Date;
        VerkInstelRec: Record "Sales & Receivables Setup";
        Memo1: Text[20];
        Memo2: Text[20];
        CustMessRec: Record "Cust. Messages";
        Mess1: Text[20];
        Mess2: Text[20];
        Berichtdatum: Text[6];
        Dag2: Text[2];
        Maand2: Text[2];
        Jaar2: Text[2];
        EANCode: Text[30];
        TempHistRec: Record "Temp File History";
        CustStockRec: Record "Cust. Stock";
        SalesSetupRec: Record "Sales & Receivables Setup";
        ItemLedgRec: Record "Item Ledger Entry";
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
        ExportTerminalRec.DELETEALL;

        // Commando's aan begin van exportbestand
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60001;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60023;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60002;
        ExportTerminalRec.INSERT;

        // Vertegenwoordiger
        Vertegenwoordiger := FORMAT(ActieveTerminal);
        WHILE STRLEN(Vertegenwoordiger) < 2 DO
            Vertegenwoordiger := '0' + Vertegenwoordiger;

        ActieArtikelen := '000000000000';
        WHILE STRLEN(ActieArtikelen) < 12 DO
            ActieArtikelen := ActieArtikelen + '0';
        // Password
        Password := '    ';
        // Memotekst
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 40);
        IF Hulptabel50007Rec3.FIND('-') THEN
            Memotekst := Hulptabel50007Rec3."Omschrijving terminal";
        WHILE STRLEN(Memotekst) < 40 DO
            Memotekst := Memotekst + ' ';
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Vertegenwoordiger + ActieArtikelen + Password + Memotekst;
        ExportTerminalRec.INSERT;

        // Welke gegevens moeten meegenomen moeten worden?

        // Klanten
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 31);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN BEGIN
            IF NOT InitieelBestand THEN
                KlantMutatiesMaken
            ELSE
                KlantAllesMaken;
        END;

        // Artikelen
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 32);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN BEGIN
            IF NOT InitieelBestand THEN
                ArtikelMutatiesMaken
            ELSE
                ArtikelAllesMaken;
        END;

        // Sneltoetsen
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 33);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            SneltoetsenMaken;

        // Voorraad mutaties
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 34);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            VoorraadMutatiesMaken;

        // Voorraad posities
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 35);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            VoorraadPositiesMaken;

        // Openstaande posten
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 36);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            OpenstaandePostenMaken;

        // BTW-codes
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 37);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            BTWCodesMaken;

        // Contact
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 42);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            ContactMaken;

        // Garantie
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 43);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            GarantieMaken;

        // Memonw
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 44);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            MemonwMaken;

        // Bericht
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 45);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            BerichtMaken;

        // Historie
        Hulptabel50007Rec3.RESET;
        Hulptabel50007Rec3.SETRANGE(Volgnummer, 46);
        IF Hulptabel50007Rec3.FIND('-') AND
           (Hulptabel50007Rec3."Meenemen in export?" = TRUE) THEN
            HistorieMaken;

        // Commando's aan einde van exportbestand
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60003 + CR;
        ExportTerminalRec.INSERT;
    end;

    procedure BepaalVolgendeNummer(): Integer
    begin
        ExportTerminalRec2.RESET;
        IF ExportTerminalRec2.FIND('+') THEN BEGIN
            LaatsteVolgNummer := ExportTerminalRec2."Volgnr." + 1;
            EXIT(LaatsteVolgNummer);
        END ELSE
            LaatsteVolgNummer := 1;
    end;

    procedure VoorraadMutatiesMaken()
    begin
        // Voorraad mutaties
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60004;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60005;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60006;
        ExportTerminalRec.INSERT;
        ArtikelRec.RESET;
        IF ArtikelRec.FIND('-') THEN BEGIN
            REPEAT
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //IF NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                VoorraadAantal := 0;
                ActieveTerminalCode := FORMAT(ActieveTerminal);
                IF (STRLEN(ActieveTerminalCode) = 1) THEN                                                   // CS1.0
                    ActieveTerminalCode := '0' + ActieveTerminalCode;                                         // CS1.0
                ArtikelPostRec.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                ArtikelPostRec.SETRANGE("Entry Type", ArtikelPostRec."Entry Type"::Transfer);
                ArtikelPostRec.SETRANGE("Item No.", ArtikelRec."No.");
                ArtikelPostRec.SETRANGE("Location Code", ActieveTerminalCode);
                ArtikelPostRec.SETRANGE("Posting Date", LaatsteMutatieExportVoorraad, TODAY + 1);
                IF ArtikelPostRec.FIND('-') THEN BEGIN
                    // BEGIN VIGEO BB 22-12-2005
                    //VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.",1,3);
                    VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.", 1, 4);
                    // EINDE VIGEO BB
                    REPEAT
                        //BEGIN ACA RB dec. bij int. optellen
                        VoorraadAantal := VoorraadAantal + ROUND(ArtikelPostRec.Quantity, 1, '=');
                    UNTIL ArtikelPostRec.NEXT = 0;
                    IF VoorraadAantal >= 0 THEN
                        VoorraadTeken := '0'
                    ELSE BEGIN
                        VoorraadTeken := '-';
                        VoorraadAantal := ABS(VoorraadAantal);
                    END;
                    VoorraadAantalString := FORMAT(VoorraadAantal);
                    // ATW BCO 240401 begin nieuw
                    PositieKomma := 0;
                    PositieKomma := STRPOS(VoorraadAantalString, ',');
                    IF PositieKomma > 0 THEN
                        VoorraadAantalString := COPYSTR(VoorraadAantalString, 1, (PositieKomma - 1));
                    // ATW BCO 240401 eind nieuw
                    WHILE STRLEN(VoorraadAantalString) < 3 DO
                        VoorraadAantalString := '0' + VoorraadAantalString;
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := VoorraadArtikel + VoorraadTeken + VoorraadAantalString;
                    ExportTerminalRec.INSERT;
                END;
            //END;
            UNTIL ArtikelRec.NEXT = 0;
        END;
    end;

    procedure VoorraadPositiesMaken()
    begin
        // Voorraad posities

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60007;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60008;
        ExportTerminalRec.INSERT;

        ArtikelRec.RESET;
        IF ArtikelRec.FIND('-') THEN BEGIN
            REPEAT
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //IF NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                VoorraadAantal := 0;
                ActieveTerminalCode := FORMAT(ActieveTerminal);
                IF (STRLEN(ActieveTerminalCode) = 1) THEN                                                   // CS1.0
                    ActieveTerminalCode := '0' + ActieveTerminalCode;                                         // CS1.0
                ArtikelPostRec.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                ArtikelPostRec.SETRANGE("Item No.", ArtikelRec."No.");
                ArtikelPostRec.SETRANGE("Location Code", ActieveTerminalCode);
                IF ArtikelPostRec.FIND('-') THEN BEGIN
                    // BEGIN VIGEO BB 22-12-2005
                    //VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.",1,3);
                    VoorraadArtikel := COPYSTR(ArtikelPostRec."Item No.", 1, 4);
                    // EINDE VIGEO BB
                    REPEAT
                        //BEGIN ACA RB dec. bij int. optellen
                        VoorraadAantal := VoorraadAantal + ROUND(ArtikelPostRec.Quantity, 1, '=');
                    UNTIL ArtikelPostRec.NEXT = 0;
                    IF VoorraadAantal >= 0 THEN
                        VoorraadTeken := '0'
                    ELSE BEGIN
                        VoorraadTeken := '-';
                        VoorraadAantal := ABS(VoorraadAantal);
                    END;
                    VoorraadAantalString := FORMAT(VoorraadAantal);
                    // ATW BCO 240401 begin nieuw
                    PositieKomma := 0;
                    PositieKomma := STRPOS(VoorraadAantalString, ',');
                    IF PositieKomma > 0 THEN
                        VoorraadAantalString := COPYSTR(VoorraadAantalString, 1, (PositieKomma - 1));
                    // ATW BCO 240401 eind nieuw
                    WHILE STRLEN(VoorraadAantalString) < 3 DO
                        VoorraadAantalString := '0' + VoorraadAantalString;
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := VoorraadArtikel + VoorraadTeken + VoorraadAantalString;
                    ExportTerminalRec.INSERT;
                END;
            //END;
            UNTIL ArtikelRec.NEXT = 0;
        END;
    end;

    procedure ArtikelMutatiesMaken()
    begin

        // Mutaties artikelen

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60009;
        ExportTerminalRec.INSERT;

        ArtikelRec.RESET;
        ArtikelRec.SETRANGE("Last Date Modified", LaatsteMutatieExportArtikelen, (TODAY + 1));
        IF ArtikelRec.FIND('-') THEN BEGIN
            REPEAT
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //IF NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
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
                WHILE STRLEN(ArtikelArtikel) < 4 DO
                    ArtikelArtikel := '0' + ArtikelArtikel;
                //VoorraadAantalString := '0' + ArtikelArtikel;
                ArtikelOmschrijving := COPYSTR(ArtikelRec.Description, 1, 25);
                WHILE STRLEN(ArtikelOmschrijving) < 25 DO
                    ArtikelOmschrijving := ArtikelOmschrijving + ' ';
                ArtikelBTWCode := ArtikelRec."VAT Prod. Posting Group";
                ArtikelVerkoopprijs := FORMAT(ROUND(ArtikelRec."Unit Price", 0.0001, '='));
                ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, 10);
                ArtikelVerkoopprijs := DELCHR(ArtikelVerkoopprijs, '=', '.');   // Punten van duizendtallen verwijderen
                PositieKomma := 0;
                AchterKomma := '';
                PositieKomma := STRPOS(ArtikelVerkoopprijs, ',');
                IF PositieKomma > 0 THEN BEGIN
                    AchterKomma := COPYSTR(ArtikelVerkoopprijs, PositieKomma + 1, 2);
                    WHILE STRLEN(AchterKomma) < 2 DO
                        AchterKomma := AchterKomma + '0';
                    IF PositieKomma <= 5 THEN BEGIN
                        ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, PositieKomma);
                        ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                        ArtikelVerkoopprijs := CONVERTSTR(ArtikelVerkoopprijs, ',', '.');
                    END ELSE
                        ArtikelVerkoopprijs := '0000.00';
                END ELSE BEGIN
                    AchterKomma := '.00';
                    ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                END;
                WHILE STRLEN(ArtikelVerkoopprijs) < 7 DO
                    ArtikelVerkoopprijs := '0' + ArtikelVerkoopprijs;
                // nummer + factor moeder artikel
                StuklijstcomponentRec.RESET;
                StuklijstcomponentRec.SETRANGE("Parent Item No.", ArtikelRec."No.");
                IF StuklijstcomponentRec.FIND('-') THEN BEGIN
                    ArtikelNummerMoederArtikel := FORMAT(StuklijstcomponentRec."No.");
                    // BEGIN VIGEO BB 22-12-2005
                    //ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel,1,3);
                    ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel, 1, 4);
                    // EINDE VIGEO BB
                    ArtikelFactorMoederArtikel := FORMAT(StuklijstcomponentRec."Quantity per");
                    ArtikelFactorMoederArtikel := COPYSTR(ArtikelFactorMoederArtikel, 1, 2);
                    WHILE STRLEN(ArtikelFactorMoederArtikel) < 2 DO
                        ArtikelFactorMoederArtikel := '0' + ArtikelFactorMoederArtikel;
                END ELSE BEGIN
                    ArtikelNummerMoederArtikel := '0000';
                    ArtikelFactorMoederArtikel := '00';
                END;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := ArtikelArtikel + ArtikelOmschrijving + ArtikelBTWCode + ArtikelVerkoopprijs +
                                                  ArtikelNummerMoederArtikel + ArtikelFactorMoederArtikel + EANCode;
                ExportTerminalRec.INSERT;
            //END;
            UNTIL ArtikelRec.NEXT = 0;
        END;
    end;

    procedure ArtikelAllesMaken()
    begin

        // Alle artikelen

        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60010;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60009;
        ExportTerminalRec.INSERT;

        ArtikelRec.RESET;
        IF ArtikelRec.FIND('-') THEN BEGIN
            REPEAT
                // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                // BEGIN VIGEO BB 02-01-2006 FNT-84
                //IF NOT((AktieveArtikelenExporteren = TRUE) AND (ArtikelRec."Export Item" = FALSE)) THEN BEGIN
                // EINDE VIGEO BB
                ArtikelArtikel := FORMAT(ArtikelRec."No.");
                // BEGIN VIGEO BB 22-12-2005
                //ArtikelArtikel := COPYSTR(ArtikelArtikel,1,3);
                ArtikelArtikel := COPYSTR(ArtikelArtikel, 1, 4);
                // EINDE VIGEO BB
                EANCode := '0000000000000';
                WHILE STRLEN(ArtikelArtikel) < 4 DO
                    ArtikelArtikel := '0' + ArtikelArtikel;
                //VoorraadAantalString := '0' + ArtikelArtikel;
                ArtikelOmschrijving := COPYSTR(ArtikelRec.Description, 1, 25);
                WHILE STRLEN(ArtikelOmschrijving) < 25 DO
                    ArtikelOmschrijving := ArtikelOmschrijving + ' ';
                ArtikelBTWCode := ArtikelRec."VAT Prod. Posting Group";
                ArtikelVerkoopprijs := FORMAT(ROUND(ArtikelRec."Unit Price", 0.0001, '='));
                ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, 10);
                ArtikelVerkoopprijs := DELCHR(ArtikelVerkoopprijs, '=', '.');            // Punten van duizendtallen verwijderen
                PositieKomma := 0;
                AchterKomma := '';
                PositieKomma := STRPOS(ArtikelVerkoopprijs, ',');
                IF PositieKomma > 0 THEN BEGIN
                    AchterKomma := COPYSTR(ArtikelVerkoopprijs, PositieKomma + 1, 2);
                    WHILE STRLEN(AchterKomma) < 2 DO
                        AchterKomma := AchterKomma + '0';
                    IF PositieKomma <= 5 THEN BEGIN
                        ArtikelVerkoopprijs := COPYSTR(ArtikelVerkoopprijs, 1, PositieKomma);
                        ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                        ArtikelVerkoopprijs := CONVERTSTR(ArtikelVerkoopprijs, ',', '.');
                    END ELSE
                        ArtikelVerkoopprijs := '0000.00';
                END ELSE BEGIN
                    AchterKomma := '.00';
                    ArtikelVerkoopprijs := ArtikelVerkoopprijs + AchterKomma;
                END;
                WHILE STRLEN(ArtikelVerkoopprijs) < 7 DO
                    ArtikelVerkoopprijs := '0' + ArtikelVerkoopprijs;
                // nummer + factor moeder artikel
                StuklijstcomponentRec.RESET;
                StuklijstcomponentRec.SETRANGE("Parent Item No.", ArtikelRec."No.");
                IF StuklijstcomponentRec.FIND('-') THEN BEGIN
                    ArtikelNummerMoederArtikel := FORMAT(StuklijstcomponentRec."No.");
                    // BEGIN VIGEO BB 22-12-2005
                    //ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel,1,3);
                    ArtikelNummerMoederArtikel := COPYSTR(ArtikelNummerMoederArtikel, 1, 4);
                    // EINDE VIGEO BB
                    ArtikelFactorMoederArtikel := FORMAT(StuklijstcomponentRec."Quantity per");
                    ArtikelFactorMoederArtikel := COPYSTR(ArtikelFactorMoederArtikel, 1, 2);
                    WHILE STRLEN(ArtikelFactorMoederArtikel) < 2 DO
                        ArtikelFactorMoederArtikel := '0' + ArtikelFactorMoederArtikel;
                END ELSE BEGIN
                    ArtikelNummerMoederArtikel := '0000';
                    ArtikelFactorMoederArtikel := '00';
                END;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := ArtikelArtikel + ArtikelOmschrijving + ArtikelBTWCode + ArtikelVerkoopprijs +
                                                  ArtikelNummerMoederArtikel + ArtikelFactorMoederArtikel + EANCode;
                ExportTerminalRec.INSERT;
            //END;
            UNTIL ArtikelRec.NEXT = 0;
        END;
    end;

    procedure SneltoetsenMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60011;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60012;
        ExportTerminalRec.INSERT;
    end;

    procedure BTWCodesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60014;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60015;
        ExportTerminalRec.INSERT;

        BTWPBGRec.RESET;
        IF BTWPBGRec.FIND('-') THEN BEGIN
            REPEAT
                BTWIdentRec.RESET;
                BTWIdentRec.SETRANGE("VAT Identifier", BTWPBGRec.Code);
                IF BTWIdentRec.FINDFIRST THEN BEGIN
                    BTWCode := COPYSTR(BTWPBGRec.Code, 1, 1);
                    BTWPercentage := FORMAT(FORMAT(BTWIdentRec."VAT %"));
                    PositieKomma := STRPOS(FORMAT(BTWIdentRec."VAT %"), ',');
                    IF PositieKomma > 0 THEN BEGIN
                        AchterKomma := SELECTSTR(2, BTWPercentage);
                        WHILE STRLEN(AchterKomma) < 3 DO
                            AchterKomma := AchterKomma + '0';
                        BTWPercentage := COPYSTR(BTWPercentage, 1, PositieKomma);
                        BTWPercentage := BTWPercentage + AchterKomma;
                        BTWPercentage := CONVERTSTR(BTWPercentage, ',', '.');
                        WHILE STRLEN(BTWPercentage) < 6 DO
                            BTWPercentage := '0' + BTWPercentage;
                    END ELSE BEGIN
                        IF STRLEN(BTWPercentage) = 1 THEN
                            BTWPercentage := '0' + BTWPercentage + '.000';
                        // ATW 050401 begin nieuw
                        IF STRLEN(BTWPercentage) = 2 THEN
                            BTWPercentage := BTWPercentage + '.000';
                        // ATW 050401 eind nieuw
                    END;
                END;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := BTWCode + BTWPercentage;
                ExportTerminalRec.INSERT;
            UNTIL BTWPBGRec.NEXT = 0;
        END;
    end;

    procedure OpenstaandePostenMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60016;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60017;
        ExportTerminalRec.INSERT;


        KlantRec.RESET;
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                KlantenPostenRec.RESET;
                KlantenPostenRec.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                KlantenPostenRec.SETRANGE("Customer No.", KlantRec."No.");
                KlantenPostenRec.SETRANGE(Open, TRUE);
                KlantenPostenRec.SETRANGE(Positive, TRUE);
                KlantenPostenRec.SETRANGE(KlantenPostenRec."Document Type", KlantenPostenRec."Document Type"::Invoice);
                IF KlantenPostenRec.FIND('-') THEN BEGIN
                    REPEAT
                        OPostenKlantnummer := FORMAT(KlantenPostenRec."Customer No.");
                        WHILE STRLEN(OPostenKlantnummer) < 6 DO
                            OPostenKlantnummer := '0' + OPostenKlantnummer;
                        OPostenFactuurnummer := FORMAT(KlantenPostenRec."Document No.");
                        //BEGIN ACA RB Als factuurnummer > 7 dan afkorten op de laatste 7 pos
                        IF STRLEN(OPostenFactuurnummer) > 7 THEN
                            OPostenFactuurnummer := COPYSTR(OPostenFactuurnummer, STRLEN(OPostenFactuurnummer) - 6, STRLEN(OPostenFactuurnummer));
                        //EINDE ACA
                        WHILE STRLEN(OPostenFactuurnummer) < 7 DO
                            OPostenFactuurnummer := '0' + OPostenFactuurnummer;
                        OPostenFactuurDatum := FORMAT(KlantenPostenRec."Document Date");
                        OPostenFactuurDatum := COPYSTR(OPostenFactuurDatum, 1, 2) + COPYSTR(OPostenFactuurDatum, 4, 2) +
                                               COPYSTR(OPostenFactuurDatum, 7, 2);
                        OPostenOpenstaandBedrag := FORMAT(KlantenPostenRec."Remaining Amount");
                        OPostenOpenstaandBedrag := DELCHR(OPostenOpenstaandBedrag, '=', '.');
                        PositieKomma := 0;
                        AchterKomma := '';
                        PositieKomma := STRPOS(OPostenOpenstaandBedrag, ',');
                        IF PositieKomma > 0 THEN BEGIN
                            AchterKomma := COPYSTR(OPostenOpenstaandBedrag, (PositieKomma + 1), 2);
                            /*         AchterKomma := SELECTSTR(2,OPostenOpenstaandBedrag);
                                      AchterKomma := COPYSTR(AchterKomma,1,2); */
                            WHILE STRLEN(AchterKomma) < 2 DO
                                AchterKomma := AchterKomma + '0';
                            IF PositieKomma <= 8 THEN BEGIN
                                OPostenOpenstaandBedrag := COPYSTR(OPostenOpenstaandBedrag, 1, PositieKomma);
                                OPostenOpenstaandBedrag := OPostenOpenstaandBedrag + AchterKomma;
                                OPostenOpenstaandBedrag := CONVERTSTR(OPostenOpenstaandBedrag, ',', '.');
                            END ELSE
                                OPostenOpenstaandBedrag := '0000000.00';
                        END ELSE BEGIN
                            AchterKomma := '.00';
                            OPostenOpenstaandBedrag := COPYSTR(OPostenOpenstaandBedrag, 1, 7) + AchterKomma;
                        END;
                        WHILE STRLEN(OPostenOpenstaandBedrag) < 10 DO
                            OPostenOpenstaandBedrag := '0' + OPostenOpenstaandBedrag;
                        OPostenAantalAanmaningen := '00';
                        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                        ExportTerminalRec.Omschrijving := OPostenKlantnummer + OPostenFactuurnummer + OPostenFactuurDatum +
                                                          OPostenOpenstaandBedrag + OPostenAantalAanmaningen;
                        ExportTerminalRec.INSERT;
                    UNTIL KlantenPostenRec.NEXT = 0;
                END;
            UNTIL KlantRec.NEXT = 0;
        END;

    end;

    procedure KlantMutatiesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60018;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        KlantRec.SETRANGE(KlantRec."Last Date Modified", LaatsteMutatieExportKlanten, (TODAY + 1));
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT


                KlantRayonNummer := FORMAT(KlantRec.Rayon);
                WHILE STRLEN(KlantRayonNummer) < 2 DO
                    KlantRayonNummer := '0' + KlantRayonNummer;
                KlantRouteNummer := FORMAT(KlantRec.Routenummer);
                WHILE STRLEN(KlantRouteNummer) < 2 DO
                    KlantRouteNummer := '0' + KlantRouteNummer;
                KlantDropcode := FORMAT(KlantRec.Dropcode);
                WHILE STRLEN(KlantDropcode) < 2 DO
                    KlantDropcode := '0' + KlantDropcode;
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;
                KlantNaam := COPYSTR(KlantRec.Name, 1, 30);
                WHILE STRLEN(KlantNaam) < 30 DO
                    KlantNaam := KlantNaam + ' ';
                // Bezoek adres ophalen
                ShiptoAddress.SETFILTER("Customer No.", KlantRec."No.");
                ShiptoAddress.SETFILTER(Code, 'BEZOEK');
                IF ShiptoAddress.FINDFIRST THEN BEGIN
                    KlantAdres := COPYSTR(ShiptoAddress.Address, 1, 25);
                    WHILE STRLEN(KlantAdres) < 25 DO
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(ShiptoAddress."Post Code", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    WHILE STRLEN(KlantPostcode) < 6 DO
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(ShiptoAddress.City, 1, 23);
                END ELSE BEGIN
                    KlantAdres := COPYSTR(KlantRec.Bezoekadres, 1, 25);
                    WHILE STRLEN(KlantAdres) < 25 DO
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(KlantRec."Postcode bezoekadres", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    WHILE STRLEN(KlantPostcode) < 6 DO
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(KlantRec."Plaats bezoekadres", 1, 23);
                END;
                WHILE STRLEN(KlantPlaats) < 23 DO
                    KlantPlaats := KlantPlaats + ' ';
                KlantBetaaltermijn := '00'; // CS1.1 BKR
                CASE TRUE OF
                    KlantRec."Payment Terms Code" = '01':
                        BEGIN
                            KlantBetaaltermijn := '00';
                        END;
                    KlantRec."Payment Terms Code" = '02':
                        BEGIN
                            KlantBetaaltermijn := '08';
                        END;
                    KlantRec."Payment Terms Code" = '03':
                        BEGIN
                            KlantBetaaltermijn := '35';
                        END;
                    KlantRec."Payment Terms Code" = '04':
                        BEGIN
                            KlantBetaaltermijn := '00';
                        END;
                    KlantRec."Payment Terms Code" = '05':
                        BEGIN
                            KlantBetaaltermijn := '45';
                        END;
                END;
                KlantBGNummer := COPYSTR(KlantRec."Preferred Bank Account Code", 1, 9);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', Text60019);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', ' ');
                WHILE STRLEN(KlantBGNummer) < 9 DO
                    KlantBGNummer := '0' + KlantBGNummer;
                //IF KlantRec."Incasso J/N" = TRUE THEN
                //  KlantIncasso := Text60020
                //ELSE
                KlantIncasso := Text60021;
                IF (KlantRec."Payment Method Code" = '0') OR (KlantRec."Payment Method Code" = '') THEN
                    KlantBICode := '0'
                ELSE BEGIN
                    KlantBICodeTemp := FORMAT(KlantRec."Payment Method Code");
                    KlantBICode := COPYSTR(KlantBICodeTemp, 2, 1);
                END;
                //IF KlantRec."Rembours J/N" = TRUE THEN
                //  KlantRembours := Text60020
                //ELSE
                KlantRembours := Text60021;
                KlantMalusPercentage := '';
                KlantMalusPercentage := COPYSTR(KlantMalusPercentage, 1, 2);
                WHILE STRLEN(KlantMalusPercentage) < 2 DO
                    KlantMalusPercentage := '0' + KlantMalusPercentage;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantRayonNummer + KlantRouteNummer + KlantDropcode +
                                                  KlantKlantnummer + KlantNaam + KlantAdres + KlantPostcode +
                                                KlantPlaats + KlantBetaaltermijn + KlantBGNummer +
                                                KlantIncasso + KlantBICode + KlantRembours + KlantMalusPercentage;
                ExportTerminalRec.INSERT;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure KlantAllesMaken()
    begin
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60022;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60018;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                KlantRayonNummer := FORMAT(KlantRec.Rayon);
                WHILE STRLEN(KlantRayonNummer) < 2 DO
                    KlantRayonNummer := '0' + KlantRayonNummer;
                KlantRouteNummer := FORMAT(KlantRec.Routenummer);
                WHILE STRLEN(KlantRouteNummer) < 2 DO
                    KlantRouteNummer := '0' + KlantRouteNummer;
                KlantDropcode := FORMAT(KlantRec.Dropcode);
                WHILE STRLEN(KlantDropcode) < 2 DO
                    KlantDropcode := '0' + KlantDropcode;
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;
                KlantNaam := COPYSTR(KlantRec.Name, 1, 30);
                WHILE STRLEN(KlantNaam) < 30 DO
                    KlantNaam := KlantNaam + ' ';
                // Bezoek adres ophalen
                ShiptoAddress.SETFILTER("Customer No.", KlantRec."No.");
                ShiptoAddress.SETFILTER(Code, 'BEZOEK');
                IF ShiptoAddress.FINDFIRST THEN BEGIN
                    KlantAdres := COPYSTR(ShiptoAddress.Address, 1, 25);
                    WHILE STRLEN(KlantAdres) < 25 DO
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(ShiptoAddress."Post Code", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    WHILE STRLEN(KlantPostcode) < 6 DO
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(ShiptoAddress.City, 1, 23);
                END ELSE BEGIN
                    KlantAdres := COPYSTR(KlantRec.Bezoekadres, 1, 25);
                    WHILE STRLEN(KlantAdres) < 25 DO
                        KlantAdres := KlantAdres + ' ';
                    KlantPostcode := COPYSTR(KlantRec."Postcode bezoekadres", 1, 7);
                    KlantPostcode := DELSTR(KlantPostcode, 5, 1);
                    WHILE STRLEN(KlantPostcode) < 6 DO
                        KlantPostcode := KlantPostcode + ' ';
                    KlantPlaats := COPYSTR(KlantRec."Plaats bezoekadres", 1, 23);
                END;
                WHILE STRLEN(KlantPlaats) < 23 DO
                    KlantPlaats := KlantPlaats + ' ';
                CASE TRUE OF
                    KlantRec."Payment Terms Code" = '01':
                        BEGIN
                            KlantBetaaltermijn := '00';
                        END;
                    KlantRec."Payment Terms Code" = '02':
                        BEGIN
                            KlantBetaaltermijn := '08';
                        END;
                    KlantRec."Payment Terms Code" = '03':
                        BEGIN
                            KlantBetaaltermijn := '35';
                        END;
                    KlantRec."Payment Terms Code" = '04':
                        BEGIN
                            KlantBetaaltermijn := '00';
                        END;
                    KlantRec."Payment Terms Code" = '05':
                        BEGIN
                            KlantBetaaltermijn := '45';
                        END;
                END;
                KlantBGNummer := COPYSTR(KlantRec."Preferred Bank Account Code", 1, 9);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', Text60019);
                KlantBGNummer := DELCHR(KlantBGNummer, '<>', ' ');
                WHILE STRLEN(KlantBGNummer) < 9 DO
                    KlantBGNummer := '0' + KlantBGNummer;
                //IF KlantRec."Incasso J/N" = TRUE THEN
                //  KlantIncasso := Text60020
                //ELSE
                KlantIncasso := Text60021;
                IF (KlantRec."Payment Method Code" = '0') OR (KlantRec."Payment Method Code" = '') THEN
                    KlantBICode := '0'
                ELSE BEGIN
                    KlantBICodeTemp := FORMAT(KlantRec."Payment Method Code");
                    KlantBICode := COPYSTR(KlantBICodeTemp, 2, 1);
                END;
                //IF KlantRec."Rembours J/N" = TRUE THEN
                //  KlantRembours := Text60020
                //ELSE
                KlantRembours := Text60021;
                KlantMalusPercentage := '';
                KlantMalusPercentage := COPYSTR(KlantMalusPercentage, 1, 2);
                WHILE STRLEN(KlantMalusPercentage) < 2 DO
                    KlantMalusPercentage := '0' + KlantMalusPercentage;
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantRayonNummer + KlantRouteNummer + KlantDropcode +
                                                  KlantKlantnummer + KlantNaam + KlantAdres + KlantPostcode +
                                                  KlantPlaats + KlantBetaaltermijn + KlantBGNummer +
                                                  KlantIncasso + KlantBICode + KlantRembours + KlantMalusPercentage;
                ExportTerminalRec.INSERT;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure ContactMaken()
    begin
        //ContactMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60024;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60025;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Laatste contactdatum en contactsoort
                KlantenPosten2Rec.RESET;
                KlantenPosten2Rec.SETCURRENTKEY(KlantenPosten2Rec."Customer No.", KlantenPosten2Rec."Document Type");
                KlantenPosten2Rec.SETRANGE(KlantenPosten2Rec."Customer No.", KlantRec."No.");
                KlantenPosten2Rec.SETFILTER(KlantenPosten2Rec."Document Type", '%1|%2', KlantenPosten2Rec."Document Type"::"Credit Memo",
                                                                                      KlantenPosten2Rec."Document Type"::Invoice);
                IF KlantenPosten2Rec.FIND('+') THEN BEGIN
                    LtstContDat := '000000';
                    LtstContSrt := '0';
                    Dag := '';
                    Maand := '';
                    Jaar := '';
                    Dag := FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 1));
                    IF STRLEN(Dag) < 2 THEN
                        Dag := '0' + Dag;
                    Maand := FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 2));
                    IF STRLEN(Maand) < 2 THEN
                        Maand := '0' + Maand;
                    Jaar := COPYSTR(FORMAT(DATE2DMY(KlantenPosten2Rec."Document Date", 3)), 3, 2);
                    //BEGIN VIGEO RB
                    //LtstContDat := Dag + Maand + Jaar;
                    LtstContDat := Jaar + Maand + Dag;
                    //EINDE VIGEO
                    IF STRLEN(KlantenPosten2Rec."Document No.") < 7 THEN
                        LtstContSrt := 'S'
                    ELSE BEGIN
                        CASE COPYSTR(KlantenPosten2Rec."Document No.", 1, 2) OF
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
                        END;
                        IF COPYSTR(KlantenPosten2Rec."Document No.", 1, 1) = '8' THEN
                            LtstContSrt := 'A';
                    END;
                END;

                //Wegschrijven naar export
                ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                ExportTerminalRec.Omschrijving := KlantKlantnummer + LtstContDat + LtstContSrt;
                ExportTerminalRec.INSERT;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure GarantieMaken()
    begin
        //GarantieMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60026;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60027;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Serienummer en garantie
                OnderhoudsRegRec.RESET;
                OnderhoudsRegRec.SETCURRENTKEY(OnderhoudsRegRec.Klantnummer, OnderhoudsRegRec.Actief);
                OnderhoudsRegRec.SETRANGE(OnderhoudsRegRec.Klantnummer, KlantRec."No.");
                OnderhoudsRegRec.SETRANGE(OnderhoudsRegRec.Actief, TRUE);
                IF OnderhoudsRegRec.FIND('-') THEN BEGIN
                    REPEAT
                        Serienr := '0000000000';
                        GarantieTotDatum := 0D;
                        Garantie := '0';
                        Serienr := OnderhoudsRegRec.Serienummer;
                        WHILE STRLEN(Serienr) < 10 DO
                            Serienr := Serienr + ' ';
                        IF ArtRec.GET(OnderhoudsRegRec."Type apparaat") THEN;
                        //GarantieTotDatum := CALCDATE(ArtRec.Garantieperiode,OnderhoudsRegRec.Opvoerdatum);
                        //IF GarantieTotDatum < WORKDATE THEN
                        Garantie := 'N';
                        //ELSE
                        //  Garantie := 'J';

                        //Wegschrijven naar export
                        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                        ExportTerminalRec.Omschrijving := KlantKlantnummer + Serienr + Garantie;
                        ExportTerminalRec.INSERT;
                    UNTIL OnderhoudsRegRec.NEXT = 0;
                END;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure MemonwMaken()
    begin
        //MemonwMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60028;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60029;
        ExportTerminalRec.INSERT;

        VerkInstelRec.GET;
        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Memo's vullen
                Memo1 := '';
                Memo2 := '';

                //IF VerkInstelRec."General Memo" <> '' THEN BEGIN
                //  Memo1 := VerkInstelRec."General Memo";
                //  Memo2 := KlantRec."Cust.Memo1";
                //END ELSE BEGIN
                Memo1 := KlantRec."Cust.Memo1";
                Memo2 := KlantRec."Cust.Memo2";
                //END;
                WHILE STRLEN(Memo1) < 20 DO
                    Memo1 := Memo1 + ' ';
                WHILE STRLEN(Memo2) < 20 DO
                    Memo2 := Memo2 + ' ';

                //Wegschrijven naar export
                IF (Memo1 <> '                    ') OR (Memo2 <> '                    ') THEN BEGIN
                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                    ExportTerminalRec.Omschrijving := KlantKlantnummer + Memo1 + Memo2;
                    ExportTerminalRec.INSERT;
                END;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure BerichtMaken()
    begin
        //BerichtMaken
        //6126 (25-09-06 RB) BEGIN Uitslashen ~KB regel
        //ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        //ExportTerminalRec.Omschrijving := Text60030;
        //ExportTerminalRec.INSERT;
        //6126 (25-09-06 RB) END
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60031;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Klantberichten
                CustMessRec.RESET;
                //BEGN VIGEO RB
                //CustMessRec.SETCURRENTKEY(CustMessRec."Customer No.",CustMessRec."Confirm Date");
                CustMessRec.SETCURRENTKEY(CustMessRec."Customer No.", CustMessRec."To Send");
                //EINDE VIGEO
                CustMessRec.SETRANGE(CustMessRec."Customer No.", KlantRec."No.");
                //BEGIN VIGEO RB
                //CustMessRec.SETFILTER(CustMessRec."Confirm Date",'%1',0D);
                CustMessRec.SETFILTER(CustMessRec."To Send", '%1', TRUE);
                //EINDE VIGEO
                IF CustMessRec.FIND('-') THEN BEGIN
                    REPEAT
                        Mess1 := '';
                        Mess2 := '';
                        Berichtdatum := '';
                        Dag2 := '';
                        Maand2 := '';
                        Jaar2 := '';
                        Mess1 := CustMessRec."Cust. Message 1";
                        WHILE STRLEN(Mess1) < 20 DO
                            Mess1 := Mess1 + ' ';
                        Mess2 := CustMessRec."Cust. Message 2";
                        WHILE STRLEN(Mess2) < 20 DO
                            Mess2 := Mess2 + ' ';
                        Dag2 := FORMAT(DATE2DMY(CustMessRec."Message Date", 1));
                        IF STRLEN(Dag2) < 2 THEN
                            Dag2 := '0' + Dag2;
                        Maand2 := FORMAT(DATE2DMY(CustMessRec."Message Date", 2));
                        IF STRLEN(Maand2) < 2 THEN
                            Maand2 := '0' + Maand2;
                        Jaar2 := COPYSTR(FORMAT(DATE2DMY(CustMessRec."Message Date", 3)), 3, 2);
                        //BEGIN VIGEO RB
                        //Berichtdatum := Dag2 + Maand2 + Jaar2;
                        Berichtdatum := Jaar2 + Maand2 + Dag2;
                        //EINDE VIGEO

                        //Wegschrijven naar export
                        IF (Mess1 <> '                    ') OR (Mess2 <> '                    ') THEN BEGIN
                            ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                            ExportTerminalRec.Omschrijving := KlantKlantnummer + Berichtdatum + Mess1 + Mess2;
                            ExportTerminalRec.INSERT;
                        END;

                        //Veld in cust. message bijwerken dat deze message verzonden is
                        CustMessRec."To Send" := FALSE;
                        CustMessRec.MODIFY;
                    UNTIL CustMessRec.NEXT = 0;
                END;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;

    procedure HistorieMaken()
    var
        ItemRecLO: Record Item;
    begin
        //HistorieMaken
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60032;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60000;
        ExportTerminalRec.INSERT;
        ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
        ExportTerminalRec.Omschrijving := Text60033;
        ExportTerminalRec.INSERT;

        KlantRec.RESET;
        KlantRec.SETCURRENTKEY(Rayon, "No.", Routenummer, Dropcode);
        KlantRec.SETRANGE(Rayon, ActieveTerminal);
        IF KlantRec.FIND('-') THEN BEGIN
            REPEAT
                //Klantnr.
                KlantKlantnummer := COPYSTR(KlantRec."No.", 1, 6);
                WHILE STRLEN(KlantKlantnummer) < 6 DO
                    KlantKlantnummer := '0' + KlantKlantnummer;

                //Leegmaken van de hulptabel
                TempHistRec.DELETEALL;

                //Vullen van de hulptabel
                //Doorlopen Voorraadopnamen
                SalesSetupRec.GET();
                CustStockRec.SETCURRENTKEY(CustStockRec."Cust. No.", CustStockRec."Item No.",
                                           CustStockRec."Check Date");
                CustStockRec.SETRANGE(CustStockRec."Cust. No.", KlantRec."No.");
                CustStockRec.SETFILTER(CustStockRec."Check Date", '%1..%2', CALCDATE(SalesSetupRec."Max. Historie Time", WORKDATE), WORKDATE);
                IF CustStockRec.FIND('-') THEN BEGIN
                    REPEAT
                        TempHistRec.INIT;
                        TempHistRec."Cust. No." := CustStockRec."Cust. No.";
                        TempHistRec."Item No." := CustStockRec."Item No.";
                        TempHistRec."Date stock/ordered" := CustStockRec."Check Date";
                        TempHistRec."Quantity Stock" := CustStockRec."Quantity in stock";
                        TempHistRec.Counted := TRUE;
                        TempHistRec.INSERT;
                    UNTIL CustStockRec.NEXT = 0;
                END;

                //Doorlopen artikelposten
                ItemLedgRec.SETCURRENTKEY(ItemLedgRec."Source Type", ItemLedgRec."Source No.",
                                          ItemLedgRec."Entry Type", ItemLedgRec."Posting Date");
                ItemLedgRec.SETRANGE(ItemLedgRec."Source Type", ItemLedgRec."Source Type"::Customer);
                ItemLedgRec.SETRANGE(ItemLedgRec."Source No.", KlantRec."No.");
                ItemLedgRec.SETRANGE(ItemLedgRec."Entry Type", ItemLedgRec."Entry Type"::Sale);
                ItemLedgRec.SETFILTER(ItemLedgRec."Posting Date", '%1..%2', CALCDATE(SalesSetupRec."Max. Historie Time", WORKDATE), WORKDATE);
                IF ItemLedgRec.FIND('-') THEN BEGIN
                    REPEAT
                        IF NOT TempHistRec.GET(ItemLedgRec."Source No.", ItemLedgRec."Item No.", ItemLedgRec."Posting Date") THEN BEGIN
                            TempHistRec.INIT;
                            TempHistRec."Cust. No." := ItemLedgRec."Source No.";
                            TempHistRec."Item No." := ItemLedgRec."Item No.";
                            TempHistRec."Date stock/ordered" := ItemLedgRec."Posting Date";
                            TempHistRec."Quantity Ordered" := ABS(ItemLedgRec.Quantity);
                            TempHistRec.INSERT;
                        END ELSE BEGIN
                            TempHistRec."Quantity Ordered" := TempHistRec."Quantity Ordered" + ABS(ItemLedgRec.Quantity);
                            TempHistRec.MODIFY;
                        END;
                    UNTIL ItemLedgRec.NEXT = 0;
                END;

                TempHistRec.RESET;
                TempHistRec.SETCURRENTKEY(TempHistRec."Cust. No.", TempHistRec."Item No.", TempHistRec."Date stock/ordered");
                TempHistRec.ASCENDING(FALSE);

                RecCounter := 1;
                "LastItemNo." := '';

                IF TempHistRec.FIND('-') THEN BEGIN
                    REPEAT
                        IF ItemRecLO.GET(TempHistRec."Item No.") THEN BEGIN
                            // BEGIN VIGEO BB 20-02-2006 FNT-84 NIET beschreven in DRD, alleen historie moet worden geexporteerd
                            //IF NOT((AktieveArtikelenExporteren = TRUE) AND (ItemRecLO."Export Item" = FALSE)) THEN BEGIN
                            IF (ItemRecLO."Export Item" = TRUE) THEN BEGIN
                                IF TempHistRec."Item No." = "LastItemNo." THEN
                                    RecCounter := RecCounter + 1
                                ELSE
                                    RecCounter := 1;

                                IF RecCounter <= 3 THEN BEGIN
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
                                    IF STRLEN(Dag3) < 2 THEN
                                        Dag3 := '0' + Dag3;
                                    Maand3 := FORMAT(DATE2DMY(TempHistRec."Date stock/ordered", 2));
                                    IF STRLEN(Maand3) < 2 THEN
                                        Maand3 := '0' + Maand3;
                                    Jaar3 := COPYSTR(FORMAT(DATE2DMY(TempHistRec."Date stock/ordered", 3)), 3, 2);
                                    //BEGIN VIGEO RB
                                    //CheckDate := Dag3 + Maand3 + Jaar3;
                                    CheckDate := Jaar3 + Maand3 + Dag3;
                                    //EINDE VIGEO

                                    QuantityOrd := FORMAT(TempHistRec."Quantity Ordered");
                                    WHILE STRLEN(QuantityOrd) < 3 DO
                                        QuantityOrd := '0' + QuantityOrd;
                                    QuantityStock := FORMAT(TempHistRec."Quantity Stock");
                                    WHILE STRLEN(QuantityStock) < 3 DO
                                        QuantityStock := '0' + QuantityStock;

                                    IF TempHistRec.Counted = TRUE THEN
                                        CountedStock := 'J'
                                    ELSE
                                        CountedStock := 'N';

                                    ExportTerminalRec."Volgnr." := BepaalVolgendeNummer;
                                    ExportTerminalRec.Omschrijving := KlantKlantnummer + "ItemNo." + CheckDate + QuantityStock + QuantityOrd +
                        CountedStock;
                                    ExportTerminalRec.INSERT;
                                END;

                                "LastItemNo." := TempHistRec."Item No.";
                            END;
                        END;
                    UNTIL TempHistRec.NEXT = 0;
                END;
            UNTIL KlantRec.NEXT = 0;
        END;
    end;
}

