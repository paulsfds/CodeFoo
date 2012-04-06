class CodeFooController < ApplicationController
  MAX_DIGIT_PERMUTATIONS = 10
  MAX_LETTER_PERMUTATIONS = 26
  DIGITS = "digits"
  LETTERS = "letters"

  def index
    population = params[:population].to_i
    if population
      @answer = generate_license_plates(population)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def generate_license_plates(population)
    answer = {
        :population => population,
        :pattern => nil,
        :total_plates => nil,
        :excess_plates => nil
    }

    # start with 1 letter and 1 digit
    num_of_letters = 1
    num_of_digits = 1

    # first see if we can meet or exceed the population by just using all digits
    while MAX_DIGIT_PERMUTATIONS**num_of_digits < population
      num_of_digits += 1
    end

    # store the all digits result as our current best answer
    answer[:total_plates] = MAX_DIGIT_PERMUTATIONS**num_of_digits
    answer[:pattern] = generate_pattern(num_of_digits, DIGITS)

    # second see if we can meet or exceed the population by just using all letters
    while MAX_LETTER_PERMUTATIONS**num_of_letters < population
      num_of_letters += 1
    end

    # check to see if using all letters resulted in a lower population than what was computed for all digits
    if answer[:total_plates] > MAX_LETTER_PERMUTATIONS**num_of_letters
      answer[:total_plates] = MAX_LETTER_PERMUTATIONS**num_of_letters
      answer[:pattern] = generate_pattern(num_of_letters, LETTERS)
    end

    # third see if we can compute an even lower population using a combination of digits and letters. first try more
    # digits than letters because it will result in a lower population than more letters than digits. in other words
    # try num_of_digits > num_of_letters, then increase num_of_letters until num_of_letters > num_of_digits.
    (num_of_digits-2).downto(1).each do |i|
      (1..(num_of_digits-2)).each do |j|
        if MAX_DIGIT_PERMUTATIONS**i*MAX_LETTER_PERMUTATIONS**j >= population
          if answer[:total_plates] > MAX_DIGIT_PERMUTATIONS**i*MAX_LETTER_PERMUTATIONS**j
            answer[:total_plates] = MAX_DIGIT_PERMUTATIONS**i*MAX_LETTER_PERMUTATIONS**j
            answer[:pattern] = generate_pattern(i, DIGITS) + ", " + generate_pattern(j, LETTERS)
          end
        end
      end
    end

    answer[:excess_plates] = answer[:total_plates] - population

    return answer
  end

  # Generates the license plate pattern as a string. If the num is <= 1, make the type singular, otherwise use the
  # plural form.
  def generate_pattern(num, type)
    if num <= 1
      return "#{num} #{type.singularize}"
    else
      return "#{num} #{type}"
    end
  end
end
