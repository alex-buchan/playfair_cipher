
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
    super_array
end


def check_same_row(chunk, matrix)
    chunk = chunk.split('')
    result = []
    matrix.each { |row| result.push(row.include?(chunk[0]) && row.include?(chunk[1]))}
    return result.any?
end

def check_same_column(chunk, matrix)
    pair_indexes = find_pair_indexes(chunk, matrix)
    pair_indexes[0] == pair_indexes[1]
end

def find_pair_indexes(chunk, matrix)
    chunk = chunk.split('')
    pair_indexes = chunk.map do |pair|
        var = matrix.collect {|ind| ind.index(pair)}
        var.delete_if { |result| result == nil }
        var[0]
    end
    return pair_indexes
end

def transform(plaintext, matrix)
    chunk_array = plaintext.split(' ')
    print "chunk_array: ", chunk_array, "\n"
    chunk_array.each do |chunk|
        print "chunk: ", chunk, "\n"
        if check_same_row(chunk, matrix)
            puts "ROW!" 
        elsif check_same_column(chunk, matrix)  
            puts "COLUMN!" 
        else
            puts "OTHER!" 
        end
    end
end

# print "Please enter some text: "
# user_input = gets.chomp
plaintext = prepare_plaintext("I am... the coolest guy ever!")
plaintext = pair_letters_of_text(plaintext)
matrix = make_5d_array("monarchy")
transform(plaintext, matrix)