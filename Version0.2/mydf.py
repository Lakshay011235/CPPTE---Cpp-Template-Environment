def modify_text(input_file, output_file, append_string):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            modified_line = line.replace('(', '^( ').replace(')', '^)').replace('<', '^<').replace('>', '^>').replace('"', '^"').replace('&', '^&').replace('|', '^|')
            if modified_line == '\n':
                modified_line = "echo." + append_string + '\n'
                print("BLANKY")
            else: 
                modified_line = "echo " + modified_line.rstrip() + append_string + '\n'
            outfile.write(modified_line)

# Usage example:
input_file = 'input.txt'      # Path to the input text file
output_file = 'output.txt'    # Path to the output text file
append_string = ' >> test_suite.h 2>>nul ' # String to append at the end of each line

modify_text(input_file, output_file, append_string)
