require 'axlsx'

class ExcelData

  def initialize(name_sheet)
    @name_sheet = name_sheet
    @p = Axlsx::Package.new
    @wb = @p.workbook
    @lines = []
  end

  def head_text(sheet)
    sheet.add_row ['N', 't, с', 'V, м/с', 'y, м', 'x, м', 'm, кг', 'θ, град', 'θ, рад']
  end

  def create_line(parameters)
    @lines << parameters
  end

  def create_sheet
    @wb.add_worksheet(name: @name_sheet) do |sheet|
      head_text(sheet)
      @lines.each do |line|
        sheet.add_row(line)
      end
    end
  end

  def save
    @p.serialize 'data/Результаты расчета.xlsx'
  end
end

