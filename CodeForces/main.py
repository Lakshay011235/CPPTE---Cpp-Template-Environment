import json  
import sys  
import requests  
import os  
  
if not os.path.exists( "../problemset.json"):  
    problem_set_json = requests.get( "https://codeforces.com/api/problemset.problems").text  
    data = json.loads( problem_set_json)["result"]["problems"]  
  
else:  
    with open( 'problemset.json', 'r', encoding='utf-8') as file:  
        data = json.load( file)  
  
  
  
def get_problem( name_or_id, index=None):  
    """  
    Args:  
        `name_or_id ( string)`: Get the problem with given name or contest id  
        `index ( string, optional)`: Additional parameter to support contest id. Defaults to None.  
  
    Returns:  
        `{'contestId': int,`  
        `'index': string,`  
        `'name': string,`  
        `'tags': list[string],`  
        `'type': string}`  
    """  
    problem = []  
    nullProblem = { 'contestId': 0,  
                    'index': '0',  
                    'name': '',  
                    'tags': [],  
                    'type': ''}  
  
    # Get problem via problem name  
    if index is None:  
        problem = [result for result in data if result["name"] == name_or_id]  
  
    # Get problem via id and index  
    elif str( name_or_id).isdecimal( ):  
        problem = [result for result in data if result["contestId"] == int( name_or_id) and result["index"] == index]  
  
    problem = nullProblem if len( problem) == 0 else problem[0]  
    return problem  
  
  
def extract_problem_div( input_string, className="problem-statement"):  
    # Define the start and end markers for the div  
    start_marker = f'<div class="{className}">'  
  
    stack = 0  
  
    # Find the start and end positions  
    start_pos = input_string.find( start_marker)  
    if start_pos == -1:  
        return None  # The div was not found  
  
    i = start_pos  
    length = len( input_string)  
  
    while i < length:  
        if input_string[i:i+4] == '<div':  
            stack += 1  
            i += 4  
        elif input_string[i:i+6] == '</div>':  
            stack -= 1  
            i += 6  
        else:  
            i += 1  
  
        if stack == 0:  
            break  
  
    return input_string[start_pos: i]  
  
  
def extract_problem_description_div( input_string):  
    # Define the start and end markers for the div  
    start_marker = f'<div class="header">'  
    end_marker = f'<div class="input-specification">'  
  
    stack = 0  
  
    # Find the start and end positions  
    start_pos = input_string.find( start_marker)  
    if start_pos == -1:  
        return None  # The div was not found  
  
    i = start_pos  
    length = len( input_string)  
  
    while i < length:  
        if input_string[i:i+4] == '<div':  
            stack += 1  
            i += 4  
        elif input_string[i:i+6] == '</div>':  
            stack -= 1  
            i += 6  
        else:  
            i += 1  
  
        if stack == 0:  
            break  
  
    return input_string[i: input_string.find( end_marker)]  
  
  
def extract_text_content( input_string, is_output=False, is_math=False):  
    text_content = []  
    inside_tag = False  
    current_text = []  
  
    # Specially for math  
    if is_math:  
        return extract_text_content( input_string).replace( "$$$", "$")  
    # Specially for output block  
    if is_output:  
        return extract_text_content( input_string).replace( "Output", "").replace( "Input", "").strip( )  
  
    for char in input_string:  
        if char == '<':  
            if current_text:  
                text_content.append( ''.join( current_text))  
                current_text = []  
            inside_tag = True  
        elif char == '>':  
            inside_tag = False  
            text_content.append( ' ')  
        elif not inside_tag:  
            current_text.append( char)  
  
    if current_text:  
        text_content.append( ''.join( current_text))  
  
    return ''.join( text_content).strip( )  
  
  
def extract_metric_content( input_string, getImage=True, is_IO=False):  
    input_string = input_string.replace( "\n", "")  
    text_content = []  
    inside_tag = False  
    current_text = []  
    tag_content = ""  
    image_text = ""  
  
    for char in input_string:  
        if char == '<':  
            if current_text:  
                text_content.append( ''.join( current_text))  
                current_text = []  
            inside_tag = True  
  
        elif char == '>':  
            inside_tag = False  
            if tag_content[:3] == "img":  
                start_pos = tag_content.find( "src=") + 5  
                end_pos = start_pos + tag_content[start_pos:].find( "\"")  
                image_text = f"![response-image]( {tag_content[start_pos:end_pos]})"  
  
            if tag_content[:2] == "li":  
                image_text = "\n- "  
  
            if tag_content[:3] == "/ul" or tag_content[:2] == "/ol":  
                image_text = "\n"  
  
            tag_content = ""  
            text_content.append( '>')  
  
            if getImage and image_text != "":  
                text_content.append( f"{image_text}")  
                image_text = ""  
  
        elif not inside_tag:  
            current_text.append( char)  
        else:  
            tag_content += char  
  
    if current_text:  
        text_content.append( ''.join( current_text))  
  
    if is_IO:  
        return ''.join( text_content).replace( ">>", "\n").replace( ">", "").replace( "Input", "").replace( "Output", "").replace( "$$$", "$").strip( )  
  
    return ''.join( text_content).replace( ">>", "\n").replace( ">", "").replace( "$$$", "$").strip( )  
  
  
# Check the number of command-line arguments  
if len( sys.argv) < 2:  
    print( "Insufficient arguments: Needed file name")  
    sys.exit( 1)  
  
# Problem name  
if len( sys.argv) == 2:  
    problem_info = get_problem( sys.argv[1])  
  
# Problem id and index  
if len( sys.argv) == 3:  
    problem_info = get_problem( sys.argv[1], sys.argv[2])  
  
  
problem_url = f"https://codeforces.com/problemset/problem/{problem_info["contestId"]}/{problem_info["index"]}"  
  
response = requests.get( problem_url)  
  
if response.status_code == 200:  
    response_text = response.text  
else:  
    response_text = ""  
  
problem_raw = extract_problem_div( response_text)  
  
problem_header = extract_problem_div( problem_raw, "header")  
problem_title = extract_problem_div( problem_header, "title")  
problem_time_limit = extract_problem_div( problem_header, "time-limit")  
problem_memory_limit = extract_problem_div( problem_header, "memory-limit")  
problem_input_file = extract_problem_div( problem_header, "input-file")  
problem_output_file = extract_problem_div( problem_header, "output-file")  
  
problem_description = extract_problem_description_div( problem_raw)  
  
problem_input_specification = extract_problem_div( problem_raw, "input-specification")  
problem_output_specification = extract_problem_div( problem_raw, "output-specification")  
  
problem_sample_tests = extract_problem_div( problem_raw, "sample-tests")  
problem_sample_test_input = extract_problem_div( problem_sample_tests, "input")  
problem_sample_test_output = extract_problem_div( problem_sample_tests, "output")  
  
problem_note = extract_problem_div( problem_raw, "note")  
  
  
readme_content = f""  
readme_content += f"# {extract_text_content( problem_title)} \n --- \n"  
readme_content += f"\t{extract_text_content( problem_time_limit)}\n"  
readme_content += f"\t{extract_text_content( problem_memory_limit)}\n"  
readme_content += f"\t{extract_text_content( problem_input_file)}\n"  
readme_content += f"\t{extract_text_content( problem_output_file)}\n"  
readme_content += f"{extract_metric_content( problem_description)}\n"  
readme_content += f"#### Input\n{extract_metric_content( problem_input_specification)[5:]}\n"  
readme_content += f"#### Output\n{extract_metric_content( problem_output_specification)[6:]}\n"  
readme_content += f"#### Example\n##### Input\n<pre>{extract_metric_content( problem_sample_test_input)[5:]}</pre>\n"  
readme_content += f"##### Output\n<pre>{extract_text_content( problem_sample_test_output, is_output=True)}</pre>\n"  
readme_content += f"##### Note\n{extract_metric_content( problem_note)[5:]}\n"  
  
# Make readme  
with open( 'README.md', 'w') as f:  
    f.write( readme_content)  
  
  
os.makedirs( 'output', exist_ok=True)  
  
# Make input  
with open( 'output/input.txt', 'w') as f:  
    f.write( extract_metric_content( problem_sample_test_input)[6:])  
  
# Make output  
with open( 'output/expected_output.txt', 'w') as f:  
    f.write( extract_text_content( problem_sample_test_output, is_output=True))  
  
print( f"{extract_text_content( problem_title).replace( ".", "").strip( ).replace( " ", "_")}")  
