require 'json'

GRADE_POINTS = {
  "F" => 0,
  "E" => 10,
  "D" => 12.5,
  "C" => 15,
  "B" => 17.5,
  "A" => 20
}

file = File.read('betyg.json')
data = JSON.parse(file)

previous_merit = nil

data.each do |term|
  year = term["value"]
  grades1 = term.dig("subjectGradesListModel", "subjectsGradeData") || []
  grades2 = term.dig("subjectGradesListModel", "onHoldSubjectsGradeData") || []
  all_grades = grades1 + grades2

  merit = all_grades.sum do |subject|
    grade = subject.dig("currentGrade", "value")
    GRADE_POINTS[grade] || 0
  end

  if previous_merit
    difference = merit - previous_merit
    puts "#{year}: #{merit} points (change: #{difference > 0 ? '+' : ''}#{difference})"
  else
    puts "#{year}: #{merit} points"
  end

  previous_merit = merit
end

print "\n"
puts "#användskola77"
