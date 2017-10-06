
# Take text and remove punctuation. 
    # .downcase
    # Regular Expressions

# Find double letters and replace second with letter 'x'
    # Regular expressions

# Find odd lengthed words and add letter 'x' at the end
    # Convert to array
    # Iteration
    # Measure the length of each word in text
    # add letter 'x' to end if word.length % 2 != 0

# Group the plaintext into pairs of letters
    # eliminate spaces
    # join into pairs


# Keyword checker (checks if keyword chosen does not have repeated letters or a j)

# Based on a matrix, so requires 2D array
# Scramble rules based on 2D array functions

# Make 5D array based on keyword
    # Length of row is 5
    # split keyword into letters
    # add keywords into rows
    # add remainder alphabet letters (omit j)

############################################################
#                    PLAINTEXT FUNCTIONS
############################################################

# Take text and remove punctuation. 
def remove_non_alphabetic_char(text)
    text.downcase!.gsub!(/[^a-z ]/i, '')
end

# Find double letters and replace second with letter 'x'
def find_double_letters(text)
    text_array = text.split(' ')
    text_array.each do |word|
        # 'teext' =~/(.)\1/ - Returns index of first doubled character
        doubled_letter_index = word =~/(.)\1/ # Add 1 to index for second doubled character
        unless doubled_letter_index == nil
            word[doubled_letter_index+1] = 'x'
        end
    end
    new_text = text_array.join('')
    return new_text
end

# Find odd lengthed words and add letter 'x' at the end
def fix_odd_numbered_text(text)
    text.length % 2 != 0 ? text += 'x' : text
end

# This returns properly formated plaintext (for Playfair cipher) given regular text
def prepare_plaintext(text)
    remove_non_alphabetic_char(text)
    new_text = find_double_letters(text)    
    result = fix_odd_numbered_text(new_text)
end

# Group the plaintext into pairs of letters
def pair_letters_of_text(text)
    text = text.scan(/../).join(' ')
end

############################################################
#                 MATRIX GENERATION AND RULES
############################################################

# Make the 5D array
def make_5d_array(keyword)
    keyword.downcase!
    keyword_array = keyword.split('')

    a_to_z = ('a'..'z').to_a 
    a_to_z.delete('j')

    keyword_array.each { |letter| a_to_z.select { |alpha| a_to_z.delete(alpha) if alpha == letter } }

    superDuper = keyword_array + a_to_z
    super_array = superDuper.each_slice(5).to_a
    print super_array, "\n"
    super_array
end


def check_same_row(chunk, super_array)
    chunk = chunk.split('')
    print chunk, "\n"
    result = []
    super_array.each { |row| result.push(row.include?(chunk[0]) && row.include?(chunk[1]))}
    return result.any?
end

def check_same_column(chunk, super_array)
    chunk = chunk.split('')
    print chunk, "\n"
    @var = 0
    super_array.each do |row| 
        @var = row.index(chunk[0])
    end
    print 'Hel', @var
end

def check_other(chunk, super_array)
end




# print "Please enter some text: "
# user_input = gets.chomp
prep = prepare_plaintext("I am... the coolest guy ever!")
puts pair_letters_of_text(prep)
super_array = make_5d_array("monarchy")
puts check_same_row('ar', super_array)