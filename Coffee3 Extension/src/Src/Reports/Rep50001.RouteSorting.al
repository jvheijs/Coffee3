report 50001 "Route Sorting"
{
    // CS1.0 160318 JHE : Gecreeerd.

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Routes; Route)
        {
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';


                    field(Rayon; Rayonsort)
                    {
                        ApplicationArea = All;
                        Caption = 'Rayon';
                        ToolTip = 'Rayon';

                        TableRelation = "Area and Customerstatus".Rayoncode;
                    }
                    field(Route; routesort)
                    {
                        ApplicationArea = All;
                        Caption = 'Route';
                        ToolTip = 'Route';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Routesort := RouteOnLookup();
                        end;

                    }

                }
            }
        }
    }

    labels
    {
    }

    var
        rayonsort: Integer;
        routesort: Integer;

    trigger OnPreReport()
    var
        dropcodenummer: Integer;
        hoogstenummer: Integer;
        aantal: Integer;
        routes1: Record Route;
        klant: Record Customer;
        routenummer: Integer;
        rayonnummer: Integer;
        maxroutenummer: Integer;
        maxrayonnummer: Integer;
    begin
        Routes.Reset;
        if rayonsort <> 0 then
            Routes.SetRange(Routes.Rayonnummer, rayonsort);
        if routesort <> 0 then
            Routes.SetRange(Routes.Routenummer, routesort);
        if Routes.FindSet() then
            repeat
                klant.Reset;
                klant.SetRange(klant."No.", Routes.Klantnummer);
                klant.FindFirst;
                Routes.Postcodesorteren := klant."Postcode bezoekadres";
                Routes.dropcodenieuw := 0;
                Routes.Modify;
            until Routes.Next = 0;

        if rayonsort <> 0 then begin
            if routesort <> 0 then begin
                // zowel rayon als route ingevuld
                Routes.Reset;
                Routes.SetRange(Routes.Rayonnummer, rayonsort);
                Routes.SetRange(Routes.Routenummer, routesort);
                Routes.SetFilter(Routes.Dropcode, '>0');
                Routes.SetCurrentKey(Routes.Dropcode, Routes.Postcodesorteren);
                dropcodenummer := 0;
                if Routes.FindSet() then
                    repeat
                        dropcodenummer := dropcodenummer + 1;
                        Routes.dropcodenieuw := dropcodenummer;
                        Routes.Modify;
                    until Routes.Next = 0;
            end else begin
                // alleen rayon ingevuld
                Routes.Reset;
                Routes.SetRange(Routes.Rayonnummer, rayonsort);
                Routes.SetFilter(Routes.Dropcode, '>0');
                Routes.SetCurrentKey(Routes.Rayonnummer, Routes.Routenummer);
                Routes.Find('+');
                maxroutenummer := Routes.Routenummer;
                routenummer := 0;
                if Routes.Find('-') then
                    repeat
                        dropcodenummer := 0;
                        routenummer := routenummer + 1;
                        Routes.SetRange(Routes.Routenummer, routenummer);
                        Routes.SetCurrentKey(Routes.Dropcode, Routes.Postcodesorteren);
                        if Routes.Find('-') then
                            repeat
                                dropcodenummer := dropcodenummer + 1;
                                Routes.dropcodenieuw := dropcodenummer;
                                Routes.Modify;
                            until Routes.Next = 0;
                    until routenummer = maxroutenummer;
            end;
        end else begin
            // alleen route ingevuld nog niet gemaakt. Is dit noodzakelijk?
            if routesort <> 0 then begin

            end else begin
                // geen rayon en geen route ingevuld
                Routes.Reset;
                Routes.SetFilter(Routes.Dropcode, '>0');
                Routes.SetCurrentKey(Routes.Rayonnummer, Routes.Routenummer);
                Routes.Find('+');
                maxrayonnummer := Routes.Rayonnummer;
                maxroutenummer := Routes.Routenummer;

                rayonnummer := 0;
                if Routes.Find('-') then
                    repeat
                        rayonnummer := rayonnummer + 1;
                        routenummer := 0;
                        Routes.SetRange(Routes.Rayonnummer, rayonnummer);
                        if Routes.Find('-') then
                            repeat
                                dropcodenummer := 0;
                                routenummer := routenummer + 1;
                                Routes.SetRange(Routes.Routenummer, routenummer);
                                Routes.SetCurrentKey(Routes.Dropcode, Routes.Postcodesorteren);
                                if Routes.Find('-') then
                                    repeat
                                        dropcodenummer := dropcodenummer + 1;
                                        Routes.dropcodenieuw := dropcodenummer;
                                        Routes.Modify;
                                    until Routes.Next = 0;
                            until routenummer = maxroutenummer;
                    until rayonnummer = maxrayonnummer;
            end;
        end;

        Commit;

        Routes.Reset;
        Routes.SetFilter(dropcodenieuw, StrSubstNo('<>%1', '0'));
        if Routes.FindSet() then
            repeat
                Routes.Dropcode := Routes.dropcodenieuw;
                Routes.Validate(Routes.Dropcode);
                Routes.wijzigen;
                Routes.dropcodenieuw := 0;
                Routes.Modify;
            until Routes.Next = 0;
    end;

    local procedure RouteOnLookup(): Integer
    var
        Route: Record Route;
        Routes: Page Routes;
    begin
        Clear(Routes);
        Routes.LookupMode := true;
        if Routes.RunModal() = ACTION::LookupOK then begin
            Routes.GetRecord(Route);
            exit(Route.Routenummer);
        end;
    end;
}