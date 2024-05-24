pageextension 50033 "CS Service Item Worksheet" extends "Service Item Worksheet"
{

    actions
    {
        addafter("&Print_Promoted")
        {

            group("CSCom&ments")
            {
                Caption = 'Com&ments';
                ShowAs = Standard;

                actionref(Faults_Promoted; Faults)
                {
                }

                actionref(Resolutions_Promoted; Resolutions)
                {
                }
                actionref(Internal_Promoted; Internal)
                {
                }
                actionref(Accessories_Promoted; Accessories)
                {
                }
                actionref(Loaners_Promoted; Loaners)
                {
                }
            }
        }

    }
}