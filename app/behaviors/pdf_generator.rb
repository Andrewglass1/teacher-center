module PdfGenerator

  PRINT_AND_SHARE_VIEW = "http://printandshare.org/proposals/view/"
  PDF_LOCATION = "http://printandshare.org/proposals/pdf/"
  class << self

    def prepare_pdf(dc_id)
      Faraday.get(PRINT_AND_SHARE_VIEW + dc_id)
    end

    def pdf_link(dc_id)
      PDF_LOCATION + dc_id
    end

    def pdf_short_link(dc_id)
      prepare_pdf(dc_id)
      pdf_reader(dc_id).match(/http:\/\/bit.ly\/\w*/)[0]
    end

    def pdf_reader(dc_id)
      PDF::Reader.new(open(pdf_link(dc_id))).pages.first.text
    end

  end
end