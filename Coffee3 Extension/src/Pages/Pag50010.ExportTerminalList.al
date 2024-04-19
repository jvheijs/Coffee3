page 50010 "Export Terminal List"
{
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Terminals)
            {
                field("Terminal 1"; TerminalMeenemen[1])
                {
                }
                field("Terminal 2"; TerminalMeenemen[2])
                {
                }
                field("Terminal 3"; TerminalMeenemen[3])
                {
                }
                field("Terminal 4"; TerminalMeenemen[4])
                {
                }
                field("Terminal 5"; TerminalMeenemen[5])
                {
                }
                field("Terminal 6"; TerminalMeenemen[6])
                {
                }
                field("Terminal 7"; TerminalMeenemen[7])
                {
                }
                field("Terminal 8"; TerminalMeenemen[8])
                {
                }
                field("Terminal 9"; TerminalMeenemen[9])
                {
                }
                field("Terminal 10"; TerminalMeenemen[10])
                {
                }
                field("Terminal 11"; TerminalMeenemen[11])
                {
                }
                field("Terminal 12"; TerminalMeenemen[12])
                {
                }
                field("Terminal 13"; TerminalMeenemen[13])
                {
                }
                field("Terminal 14"; TerminalMeenemen[14])
                {
                }
                field("Terminal 15"; TerminalMeenemen[15])
                {
                }
                field("Terminal 16"; TerminalMeenemen[16])
                {
                }
                field("Terminal 17"; TerminalMeenemen[17])
                {
                }
                field("Terminal 18"; TerminalMeenemen[18])
                {
                }
                field("Terminal 19"; TerminalMeenemen[19])
                {
                }
                field("Terminal 20"; TerminalMeenemen[20])
                {
                }
                field("Terminal 21"; TerminalMeenemen[21])
                {
                }
                field("Terminal 22"; TerminalMeenemen[22])
                {
                }
                field("Terminal 23"; TerminalMeenemen[23])
                {
                }
                field("Terminal 24"; TerminalMeenemen[24])
                {
                }
                field("Terminal 25"; TerminalMeenemen[25])
                {
                }
                field("Terminal 26"; TerminalMeenemen[26])
                {
                }
                field("Terminal 27"; TerminalMeenemen[27])
                {
                }
                field("Terminal 28"; TerminalMeenemen[28])
                {
                }
                field("Terminal 29"; TerminalMeenemen[29])
                {
                }
                field("Terminal 30"; TerminalMeenemen[30])
                {
                }
            }
            group(Data)
            {
                field("Soort bestand"; "Soort Bestand")
                {

                    trigger OnValidate()
                    begin
                        if "Soort Bestand" <> "Soort Bestand"::Initieel then begin
                            ArtikelMeenemen := true;
                            SneltoetsMeenemen := false;
                            KlantenMeenemen := true;
                            AutovoorraadPositiesMeenemen := false;
                            OpenstaandePostenMeenemen := false;
                            BTWCodesMeenemen := false;
                            MemoTekstenMeenemen := false;
                            // ATW BCO 240401 begin nieuw
                            ActieArtikelenMeenemen := false;
                            // ATW BCO 240401 eind nieuw
                            //BEGIN ACA RB
                            ContactMeenemen := true;
                            GarantieMeenemen := false;
                            MemonwMeenemen := false;
                            BerichtMeenemen := true;
                            KlantVrrdMeenemen := false;
                            HistorieMeenemen := true;
                            //EINDE ACA RB
                            CurrPage.Update;
                        end else begin
                            ArtikelMeenemen := true;
                            SneltoetsMeenemen := true;
                            KlantenMeenemen := true;
                            AutovoorraadPositiesMeenemen := true;
                            OpenstaandePostenMeenemen := true;
                            BTWCodesMeenemen := true;
                            MemoTekstenMeenemen := true;
                            // ATW BCO 240401 begin nieuw
                            ActieArtikelenMeenemen := true;
                            // ATW BCO 240401 eind nieuw
                            //BEGIN ACA RB
                            ContactMeenemen := true;
                            GarantieMeenemen := true;
                            MemonwMeenemen := true;
                            BerichtMeenemen := true;
                            KlantVrrdMeenemen := true;
                            HistorieMeenemen := true;
                            //EINDE ACA RB
                            CurrPage.Update;
                        end;
                    end;
                }
                field("Klant meenemen"; KlantenMeenemen)
                {
                }
                field("Artikel meenemen"; ArtikelMeenemen)
                {
                }
                field("Auto vrd mutaties meenemen"; AutovoorraadMutatiesMeenemen)
                {
                }
                field("Openstaande posten"; OpenstaandePostenMeenemen)
                {
                    Visible = false;
                }
                field(Sneltoetsen; SneltoetsMeenemen)
                {
                }
                field("BTW-codes"; BTWCodesMeenemen)
                {
                }
                field("Auto voorraad posities"; AutovoorraadPositiesMeenemen)
                {
                }
                field("Laatste contactsoort"; ContactMeenemen)
                {
                }
                field("Garantie meenemen"; GarantieMeenemen)
                {
                }
                field("Memo tekst"; MemonwMeenemen)
                {
                }
                field("Klant bericht"; BerichtMeenemen)
                {
                }
                field("Klant bestel/vrd historie"; HistorieMeenemen)
                {
                }
                field("Hist. akt. art. exporteren"; AktieveArtikelenExporteren)
                {
                    Visible = false;
                }
            }
            group(Memo)
            {
                field("Memo inhoud"; MemoTekst)
                {
                }
                field(Memotekst; MemoTekstenMeenemen)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Alles markeren")
            {
                Image = Process;
                trigger OnAction()
                begin

                    i := 1;
                    while i <> 31 do begin
                        TerminalMeenemen[i] := true;
                        i := i + 1;
                    end;
                    CurrPage.Update;
                end;
            }
            action(Doorgaan)
            {
                Image = Process;
                trigger OnAction()
                begin

                    if ((AutovoorraadMutatiesMeenemen = true) and (AutovoorraadPositiesMeenemen = true)) then
                        Error(Text60000);

                    // Gegevens terminal in hulptabel 50007 zetten

                    Hulptabel50007Rec.RESET();
                    Hulptabel50007Rec.ModifyAll("Meenemen in export?", false);
                    Hulptabel50007Rec.ModifyAll(Geexporteerd, false);

                    i := 1;
                    while i <> 31 do begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, i);
                        if (Hulptabel50007Rec.Find('-') and (TerminalMeenemen[i] = true)) then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                        i := i + 1;
                    end;

                    // Gegevens data-items in hulptabel zetten

                    if KlantenMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 31);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if ArtikelMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 32);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if SneltoetsMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 33);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if AutovoorraadMutatiesMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 34);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if AutovoorraadPositiesMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 35);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if OpenstaandePostenMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 36);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if BTWCodesMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 37);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if "Soort Bestand" = "Soort Bestand"::Initieel then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 39);
                        if Hulptabel50007Rec.Find('-') then
                            Hulptabel50007Rec."Meenemen in export?" := true;
                    end else begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 39);
                        if Hulptabel50007Rec.Find('-') then
                            Hulptabel50007Rec."Meenemen in export?" := false;
                    end;
                    Hulptabel50007Rec.MODIFY();

                    if MemoTekstenMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 38);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 40);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Omschrijving terminal" := MemoTekst;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end else begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 40);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Omschrijving terminal" := '';
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    // ATW BCO 240401 begin nieuw
                    if ActieArtikelenMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 41);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;
                    // ATW BCO 240401 eind nieuw

                    //BEGIN ACA RB
                    if ContactMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 42);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if GarantieMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 43);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if MemonwMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 44);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if BerichtMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 45);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;

                    if HistorieMeenemen = true then begin
                        Hulptabel50007Rec.RESET();
                        Hulptabel50007Rec.SetRange(Volgnummer, 46);
                        if Hulptabel50007Rec.Find('-') then begin
                            Hulptabel50007Rec."Meenemen in export?" := true;
                            Hulptabel50007Rec.MODIFY();
                        end;
                    end;
                    //EINDE ACA

                    // BEGIN VIGEO BB 02-01-2006 FNT-84
                    //if AktieveArtikelenExporteren = TRUE THEN BEGIN
                    //  Hulptabel50007Rec.RESET();
                    //  Hulptabel50007Rec.SETRANGE(Volgnummer,48);
                    //  if Hulptabel50007Rec.FIND('-') THEN BEGIN
                    //Hulptabel50007Rec."Meenemen in export?" := TRUE;
                    //Hulptabel50007Rec.MODIFY();
                    //END;
                    //END;
                    // EINDE VIGEO BB
                    CurrPage.CLOSE();
                end;
            }
            action(CreateExportTerminalFile)
            {
                Caption = 'Create Terminal Export File';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = ExportFile;

                trigger OnAction()
                var
                    CreateTerminalExport: Codeunit "CreateTerminalExportFile";
                begin
                    CreateTerminalExport.RUN;
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin

        if "Soort Bestand" <> "Soort Bestand"::Initieel then begin
            ArtikelMeenemen := true;
            SneltoetsMeenemen := false;
            KlantenMeenemen := true;
            AutovoorraadPositiesMeenemen := false;
            OpenstaandePostenMeenemen := false;
            BTWCodesMeenemen := false;
            MemoTekstenMeenemen := false;
            // ATW BCO 240401 begin nieuw
            ActieArtikelenMeenemen := false;
            // ATW BCO 240401 eind nieuw
            //BEGIN ACA RB
            ContactMeenemen := true;
            GarantieMeenemen := false;
            MemonwMeenemen := false;
            BerichtMeenemen := true;
            KlantVrrdMeenemen := false;
            HistorieMeenemen := true;
            //EINDE ACA RB
            CurrPage.Update;
        end;
    end;

    var
        ArtikelMeenemen: Boolean;
        SneltoetsMeenemen: Boolean;
        KlantenMeenemen: Boolean;
        AutovoorraadMutatiesMeenemen: Boolean;
        AutovoorraadPositiesMeenemen: Boolean;
        OpenstaandePostenMeenemen: Boolean;
        BTWCodesMeenemen: Boolean;
        MemoTekstenMeenemen: Boolean;
        ActieArtikelenMeenemen: Boolean;
        ContactMeenemen: Boolean;
        GarantieMeenemen: Boolean;
        MemonwMeenemen: Boolean;
        BerichtMeenemen: Boolean;
        KlantVrrdMeenemen: Boolean;
        HistorieMeenemen: Boolean;
        i: Integer;
        TerminalMeenemen: array[30] of Boolean;
        AktieveArtikelenExporteren: Boolean;
        Hulptabel50008Rec: Record "Inventory Export";
        "Soort Bestand": Option Mutaties,Initieel;
        Hulptabel50007Rec: Record "Temp. Table Export";
        MemoTekst: Text[40];
        TxtDummy: Text[1];
        Text60000: Label 'U moet of voorraadposities of voorraadmutaties kiezen!';
        Text60001: Label '------------------------------------------------------------------------';
}

