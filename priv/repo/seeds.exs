# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Routiq.Repo
alias Routiq.Compliance.{Substance, CountryRule}
alias Routiq.Accounts.User

# Ensure we're starting clean
Repo.delete_all(CountryRule)
Repo.delete_all(Substance)

# 1. Create Substances
substances = [
  %{
    name: "Fentanyl Citrate",
    cas_number: "990-73-0",
    inn_name: "Fentanyl",
    type: "Narcotic",
    properties: %{"solubility" => "water soluble", "molecular_weight" => "528.6"}
  },
  %{
    name: "Pseudoephedrine HCl",
    cas_number: "345-78-3",
    inn_name: "Pseudoephedrine",
    type: "Precursor",
    properties: %{"solubility" => "highly soluble", "state" => "solid"}
  },
  %{
    name: "Amoxicillin Trihydrate",
    cas_number: "61336-70-7",
    inn_name: "Amoxicillin",
    type: "API",
    properties: %{"class" => "antibiotic", "shelf_life" => "2 years"}
  },
  %{
    name: "Diazepam",
    cas_number: "439-14-5",
    inn_name: "Diazepam",
    type: "Psychotropic",
    properties: %{"class" => "benzodiazepine"}
  }
]

inserted_substances =
  Enum.map(substances, fn attrs ->
    %Substance{}
    |> Substance.changeset(attrs)
    |> Repo.insert!()
  end)

# 2. Create Country Rules
[fentanyl, pseudo, amox, diazepam] = inserted_substances

rules = [
  # Fentanyl rules (Highly restricted)
  %{
    substance_id: fentanyl.id,
    country_code: "US",
    schedule_class: "Schedule II",
    import_permit_required: true,
    quantity_limits: "Strict quota-based limits apply",
    labelling_rules: "DEA specified warnings required",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.deadiversion.usdoj.gov/schedules/"
  },
  %{
    substance_id: fentanyl.id,
    country_code: "GB",
    schedule_class: "Schedule II",
    import_permit_required: true,
    quantity_limits: "Home Office import license required",
    labelling_rules: "CD (Controlled Drug) marking required",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.gov.uk/government/publications/controlled-drugs-list"
  },
  %{
    substance_id: fentanyl.id,
    country_code: "DE",
    schedule_class: "BtM (Narcotic)",
    import_permit_required: true,
    quantity_limits: "BfArM authorization required",
    labelling_rules: "Special narcotic labeling (BtM)",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.bfarm.de/"
  },

  # Pseudoephedrine rules (Precursor)
  %{
    substance_id: pseudo.id,
    country_code: "US",
    schedule_class: "Listed Chemical",
    import_permit_required: true,
    quantity_limits: "Sales and import limits (CMEA)",
    labelling_rules: "Standard API labelling",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.deadiversion.usdoj.gov/"
  },
  %{
    substance_id: pseudo.id,
    country_code: "AU",
    schedule_class: "Schedule 4 / 3",
    import_permit_required: true,
    quantity_limits: "TGA import permit required",
    labelling_rules: "Standard API labelling",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.tga.gov.au/"
  },

  # Amoxicillin (Standard API)
  %{
    substance_id: amox.id,
    country_code: "US",
    schedule_class: "OTC / Rx",
    import_permit_required: false,
    quantity_limits: "None",
    labelling_rules: "FDA compliant labelling",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.fda.gov/"
  },
  %{
    substance_id: amox.id,
    country_code: "GB",
    schedule_class: "POM",
    import_permit_required: false,
    quantity_limits: "None",
    labelling_rules: "MHRA compliant labelling",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.gov.uk/mhra"
  },
  %{
    substance_id: amox.id,
    country_code: "IN",
    schedule_class: "Schedule H",
    import_permit_required: false,
    quantity_limits: "None",
    labelling_rules: "CDSCO compliant labelling",
    effective_date: ~D[2024-01-01],
    source_url: "https://cdsco.gov.in/"
  },

  # Diazepam (Psychotropic)
  %{
    substance_id: diazepam.id,
    country_code: "US",
    schedule_class: "Schedule IV",
    import_permit_required: true,
    quantity_limits: "Subject to quotas",
    labelling_rules: "DEA specified warnings required",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.deadiversion.usdoj.gov/"
  },
  %{
    substance_id: diazepam.id,
    country_code: "GB",
    schedule_class: "Schedule IV",
    import_permit_required: true,
    quantity_limits: "Home Office import license required",
    labelling_rules: "CD (Controlled Drug) marking required",
    effective_date: ~D[2024-01-01],
    source_url: "https://www.gov.uk/"
  }
]

Enum.each(rules, fn attrs ->
  %CountryRule{}
  |> CountryRule.changeset(attrs)
  |> Repo.insert!()
end)

IO.puts("Seed data generated successfully! 🚀")
