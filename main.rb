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
inserted_line = false

data.each do |term|
  year = term["value"]
  grades1 = term.dig("subjectGradesListModel", "subjectsGradeData") || []
  grades2 = term.dig("subjectGradesListModel", "onHoldSubjectsGradeData") || []
  all_grades = grades1 + grades2

  merit_value = term.dig("subjectGradesListModel", "meritValue", "value")

  merit = if year.match?(/år 9/) && merit_value
    merit_value.to_f
  else
    all_grades.sum do |subject|
      grade = subject.dig("currentGrade", "value")
      GRADE_POINTS[grade] || 0
    end
  end

  if year.match?(/år 7/) && !inserted_line
    puts "\nNedan är de som räknas:"
    inserted_line = true
  end

  if previous_merit
    difference = merit - previous_merit
    puts "#{year}: #{merit} poäng (skillnad: #{difference >= 0 ? '+' : ''}#{difference.round(2)})"
  else
    puts "#{year}: #{merit} poäng"
  end

  previous_merit = merit
end

puts "\n#användskola77"
