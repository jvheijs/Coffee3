report 50095 "Read Confirmation Found"
{
    // CS1.0 220218 JHE : Aangemaakt.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50095/Rep50095.ReadConfirmationFound.rdlc';

    UseRequestPage = true;

    dataset
    {
        dataitem("Import terminal"; "Import terminal")
        {
            DataItemTableView = SORTING(Regelsoort) WHERE(Regelsoort = CONST('LB'));
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

