report 50000 "Change Route"
{
    // CS1.0 160318 JHE : Gecreeerd.

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1));
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
                    field(RayonOud; RayonOud)
                    {
                        ApplicationArea = All;
                        Caption = 'Rayon Oud';
                        ToolTip = 'Rayon Oud';

                        TableRelation = "Area and Customerstatus".Rayoncode;
                    }
                    field(RayonNieuw; RayonNieuw)
                    {
                        ApplicationArea = All;
                        Caption = 'Rayon Nieuw';
                        ToolTip = 'Rayon Nieuw';

                        TableRelation = "Area and Customerstatus".Rayoncode;
                    }

                    field(RouteOud; RouteOud)
                    {
                        ApplicationArea = All;
                        Caption = 'Route Oud';
                        ToolTip = 'Route Oud';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RouteOud := RouteOnLookup();
                        end;
                    }

                    field(RouteNieuw; RouteNieuw)
                    {
                        ApplicationArea = All;
                        Caption = 'Route Nieuw';
                        ToolTip = 'Route Nieuw';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RouteNieuw := RouteOnLookup();
                        end;
                    }

                }
            }
        }
    }


    labels
    {
    }

    trigger OnPreReport()
    begin
        RouteRec.Reset;
        RouteRec.SetRange(RouteRec.Rayonnummer, RayonNieuw);
        RouteRec.SetRange(RouteRec.Routenummer, RouteNieuw);
        if RouteRec.Find('-') then
            Error(Text60000 +
             Text60001, RayonNieuw, RouteNieuw);

        RouteRec.Reset;
        RouteRec.SetRange(RouteRec.Rayonnummer, RayonOud);
        RouteRec.SetRange(RouteRec.Routenummer, RouteOud);
        if RouteRec.Find('-') then
            repeat
                RouteRec.Rayonnummer := RayonNieuw;
                RouteRec.Routenummer := RouteNieuw;
                RouteRec.Modify;
                KlantRec.Reset;
                KlantRec.SetRange(KlantRec."No.", RouteRec.Klantnummer);
                KlantRec.Find('-');
                KlantRec.Rayon := RayonNieuw;
                KlantRec.Routenummer := RouteNieuw;
                // ATW BCO 240401 begin nieuw
                KlantRec."Last Date Modified" := WorkDate;
                // ATW BCO 240401 eind nieuw
                KlantRec.Modify;
            until RouteRec.Next = 0;
    end;

    var
        RouteOud: Integer;
        RayonOud: Integer;
        RayonNieuw: Integer;
        RouteNieuw: Integer;
        RouteRec: Record Route;
        KlantRec: Record Customer;
        Text60000: Label 'Deze combinatie van rayonnummer %1 en routenummer %2 bestaat al./';
        Text60001: Label 'U kunt deze niet dubbel aanmaken';

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

