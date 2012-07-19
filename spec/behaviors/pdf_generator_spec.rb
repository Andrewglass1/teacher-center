require 'spec_helper'

describe PdfGenerator do

  context ".pdf_short_link" do
    it "returns the short link for the project" do
      PdfGenerator.pdf_short_link("ddddd").inspect
    end
  end
end
