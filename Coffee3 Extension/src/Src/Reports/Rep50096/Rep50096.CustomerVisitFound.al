report 50096 "Customer Visit Found"
{
    // CS1.0 220218 JHE : Aangemaakt.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50096/Rep50096.CustomerVisitFound.rdlc';

    UseRequestPage = true;

    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Import terminal"; "Import terminal")
        {
            DataItemTableView = SORTING(Regelsoort) WHERE(Regelsoort = CONST('KB'));
            column(Volgnr; "Import terminal".Volgnummer)
            {
            }
            column(Omschrijving; "Import terminal".Omschrijving)
            {
            }
            column(Regelsoort; "Import terminal".Regelsoort)
            {
            }
            column(VolgnrLbl; "Import terminal".FieldCaption(Volgnummer))
            {
            }
            column(OmschrijvingLbL; "Import terminal".FieldCaption(Omschrijving))
            {
            }
            column(RegelsoortLbl; "Import terminal".FieldCaption(Regelsoort))
            {
            }
            column(CompanyVar; CompanyName)
            {
            }
            column(TodayVar; Format(Today, 0, '<day,2>-<month,2>-<year4>'))
            {
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

    labels
    {
    }
}

