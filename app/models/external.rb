class External < ActiveRecord::Base
  attr_accessible :InningsNo, :OverNo, :BallNo, :StrikerName , :NonStrikerName , :BowlerName, :FielderName  , :Runs, :Extras, :BallType, :ShotName, :Line, :Length, :IsUncomfortable, :IsWickettakingBall, :IsWicket , :IsBeaten, :IsReleaseshot, :IsWide, :IsNoBall, :IsBye, :IsLegBye , :IsFour, :IsSix, :BowlingEnd, :BowlingDirection, :Day, :SpellNo, :WicketType, :SessionNo, :Region, :PlayingOrder, :OutBatsmanName, :StrikerBatType, :NonStrikerBatType, :BowlType, :PlayingOrder
  
  
	def self.import(file)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
		row = Hash[[header, spreadsheet.row(i)].transpose]
		external = find_by_id(row["id"]) || new
		external.attributes = row.to_hash.slice(*accessible_attributes)
		external.save!
	  end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
	  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
	  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end
  
 end
