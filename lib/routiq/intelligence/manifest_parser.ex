defmodule Routiq.Intelligence.ManifestParser do
  @moduledoc """
  Simulates the AI parsing of a batch record / manifest document to extract ingredients,
  API, excipients, and map them to regulatory substance identifiers.
  """

  @doc """
  Parses a document (simulated) and returns the extracted packing list.
  In a real scenario, this would call the Gemini 1.5 Pro API with the document content
  and a prompt to output structured JSON matching our Substance schemas.
  """
  def parse_document(_file_content) do
    # Simulating a 2-second processing time for the AI model
    Process.sleep(2000)

    {:ok, %{
      status: "success",
      confidence_score: 0.98,
      extracted_entities: [
        %{
          type: "API",
          name: "Amoxicillin Trihydrate",
          cas_number: "61336-70-7",
          amount: "500mg"
        },
        %{
          type: "API",
          name: "Clavulanate Potassium",
          cas_number: "61177-45-5",
          amount: "125mg"
        },
        %{
          type: "Excipient",
          name: "Microcrystalline Cellulose",
          cas_number: "9004-34-6",
          amount: "100mg"
        }
      ],
      compliance_flags: [
        "Contains Amoxicillin - Antibiotic API",
        "Contains Clavulanate Potassium - Beta-lactamase inhibitor"
      ]
    }}
  end
end
