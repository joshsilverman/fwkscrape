require 'csv'

@mac_address_hash = {}
CSV.foreach("Govt101 (1-10).csv") do |row|
  i, question_num , question = row
  answers = row[3,15]

  correct = ''
  incorrect = []
  answers.each do |a|
    if /(.*)\s\(Correct\)$/.match(a)
      correct = a.gsub /\s\(Correct\)$/, ""
    else 
      incorrect << a
    end
  end

  if question and correct and incorrect

    #############################
    # Insert Db Statements Here #
    #############################

    puts "Question: #{question}"
    puts "Correct: #{correct}"
    answers.each_with_index {|a, i| puts "Incorrect #{i}: #{a}"}

  else
    puts "Error!"
    break
  end
  puts ""

end