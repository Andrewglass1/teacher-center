require 'spec_helper'

describe PdfGenerator do
  let(:pdf_response) {
    "My students need twenty-five copies of Shades of Gray, five copies of Number \nthe Stars, and five copies of Bull Run.
     What did your social studies instruction \nlook like in school? Do you remember lectures? How about those black and wh
     ite \nvideos? I want to make social studies interactive and fun all while...\nFIND OUT HOW YOU CAN HELP:http://bit.ly/M
     BkJ4a\nThis project is made possible by DonorsChoose, an online charity that \nmakes it easy for anyone to help student
     s in need.\nHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social S
     tudies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lock
     ett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit
     .ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Stu
     dies ALIVE!!!http://bit.ly/MBkJ4a"
  }


  before do
    PdfGenerator.stub(:pdf_reader).and_return(pdf_response)
  end

  context ".pdf_short_link" do
    it "returns the short link for the project" do
      PdfGenerator.pdf_short_link("ddddd").inspect
    end
  end
end
