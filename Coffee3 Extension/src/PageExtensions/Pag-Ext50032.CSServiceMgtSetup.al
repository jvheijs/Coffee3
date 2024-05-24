pageextension 50032 "CS Service Mgt. Setup" extends "Service Mgt. Setup"
{
    layout
    {
        addafter(Defaults)
        {
            group("CS Default Service Lines")
            {
                Caption = 'Default Service Lines';

                part(DefaultServiceLines; "CS Default Service Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Lines';
                    ;
                }
            }
        }
    }
}
