module PdfGenerator
  PRINT_AND_SHARE_VIEW = "http://printandshare.org/proposals/view/"
  PDF_LOCATION = "http://printandshare.org/proposals/pdf/"
  class << self

    def prepare_pdf(dc_id)
      Thread.new do
        Faraday.get(PRINT_AND_SHARE_VIEW + dc_id)
      end
    end

    def pdf_link(dc_id)
      PDF_LOCATION + dc_id
    end

  end
end