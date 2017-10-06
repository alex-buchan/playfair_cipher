############################################################
#                     ENCRYPT ACTIONS
############################################################

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
#                     DECRYPT ACTIONS
############################################################

# Grab cipher text
    # Split into arrays of 2 letters each, inside a larger array
    
# remake 5D array from keyword
    # Reuse make_5d_array

# 


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
    pair_letters_of_text(result)
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
    super_array
end

# Returns a boolean if chunk is in the same row
def check_same_row(chunk, matrix)
    chunk_position = find_chunk_position(chunk, matrix)
    chunk_position[0][1] == chunk_position[1][1]
end

# Returns a boolean if chunk is in the same column
def check_same_column(chunk, matrix)
    chunk_position = find_chunk_position(chunk, matrix)
    chunk_position[0][0] == chunk_position[1][0]
end

# Returns an array with the position of the chunk letters in an array [x, y] / [col, row]
def find_chunk_position(chunk, matrix)
    chunk = chunk.split('')

    pair_column_indexes = chunk.map do |letter|
        var = matrix.collect { |row| row.index(letter) }
        var.delete_if { |result| result == nil }
        var[0]
    end

    pair_row_indexes = chunk.map do |letter|
        var = matrix.map { |row| row.include?(letter) }
        var.index(true)
    end

    letter_1 = [pair_column_indexes[0], pair_row_indexes[0]]
    letter_2 = [pair_column_indexes[1], pair_row_indexes[1]]
    result = [letter_1, letter_2]
end

def mod_5(number)
    number % 5
end

def transform(text, matrix)
    chunk_array = text.split(' ')
    @cipher_array = []
    chunk_array.each do |chunk|
        chunk_position = find_chunk_position(chunk, matrix)
        letter_1 = chunk_position[0]
        letter_2 = chunk_position[1]

        if check_same_row(chunk, matrix)
            letter_1[0] = mod_5(letter_1[0] += 1)
            letter_2[0] = mod_5(letter_2[0] += 1)
            new_chunk = [letter_1, letter_2]
            @cipher_array.push(new_chunk)
        elsif check_same_column(chunk, matrix)  
            letter_1[1] = mod_5(letter_1[1] += 1)
            letter_2[1] = mod_5(letter_2[1] += 1)
            new_chunk = [letter_1, letter_2]
            @cipher_array.push(new_chunk)
        else
            letter_1[0], letter_2[0] = letter_2[0], letter_1[0]
            new_chunk = [letter_1, letter_2]
            @cipher_array.push(new_chunk)
        end
    end

    render_to_text(@cipher_array.flatten(1), matrix)
end


def render_to_text(array, matrix)
    @cipher_array = array.map { |letter| matrix[letter[1]][letter[0]] }
end


############################################################
#                           MAIN
############################################################



def main
    print "Please enter some text you would like to encrypt: "
    user_input = gets.chomp
    print "Please enter the keyword: "
    keyword = gets.chomp
    
    original_text = "I am... the coolest guy ever!"
    plaintext = prepare_plaintext(user_input)
    matrix = make_5d_array(keyword)
    cipher_array = transform(plaintext, matrix)
    cipher_text = cipher_array.join('')
    cipher_text = cipher_text.scan(/../).join(' ')
    
    puts ''
    matrix.each { |row| print row, "\n" }
    puts ''
    print "original_text: ", user_input, "\n"
    print "plaintext: ", plaintext, "\n"
    print "cipher_text: ", cipher_text, "\n"    
    puts ''
    return cipher_text
end

main