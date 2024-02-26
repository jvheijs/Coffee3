table 50015 "Reimbursement Label"
{
    // CS1.0 070318 JvH : Created.


    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Omschrijving; Text[30])
        {
        }
        field(3; "Opnemen in campagnes"; Boolean)
        {
            InitValue = true;
        }
        field(50001; Naam; Text[50])
        {
            Description = '2000-901-51';
        }
        field(50002; Adres; Text[35])
        {
            Description = '2000-901-51';
        }
        field(50003; Plaats; Text[30])
        {
            Description = '2000-901-51';
        }
        field(50004; Bedrag; Decimal)
        {
            Description = '2000-901-51';
        }
        field(50005; Bankrekeningnr; Code[10])
        {
            Description = '2000-901-51';
        }
        field(50006; Afgedrukt; Boolean)
        {
            Description = '2000-901-51';
        }
        field(50007; Klantnr; Code[10])
        {
            Description = '2000-901-51';
        }
        field(50008; Postcode; Code[10])
        {
            Description = '2000-901-51';
        }
        field(50009; PTTEtiketGeprint; Boolean)
        {
            Description = '2000-901-54';
        }
        field(50010; "Aantal colli"; Decimal)
        {
            Description = '2000-901-54';
        }
        field(50012; Aflevernaam; Text[50])
        {
            Description = '2000-901-54';
        }
        field(50013; "Afl.contactpersoon"; Text[30])
        {
            Description = '2000-901-54';
        }
        field(50014; "Straatnaam afleveradres"; Text[30])
        {
            Description = '2000-901-54';
        }
        field(50015; "Huisnummer afleveradres"; Text[15])
        {
            Description = '2000-901-54';
        }
        field(50016; "Toevoeging afleveradres"; Text[5])
        {
            Description = '2000-901-54';
        }
        field(50019; Afleverland; Code[10])
        {
            Description = '2000-901-54';
        }
        field(50020; Locatie; Code[10])
        {
            Description = '2000-901-54';
        }
        field(50021; Betalingswijze; Code[10])
        {
            Description = '2000-901-54';
        }
        field(50022; Leveringswijze; Code[10])
        {
            Description = '2000-901-54';
        }
        field(50023; Email; text[100])
        {
            Description = 'CS2.10';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

