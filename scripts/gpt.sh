SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# @describe Use gpt to extract csv(cli definitions table) from help txt
# @option --model=gpt-3.5-turbo Specific gpt model
# @option --temperature=0.7     Specific temperature
# @arg help-file                Specific help text file. if ommit, read from stdin

log_exit() {
    echo $*
    exit 1
}

prompt() {
    cat <<-EOF
Extract all subcommands, options and positional arguments in the help text and convert it into markdown table.
Choices are multiple words separated by commas.
If the body text contains vertical bars, replace them with commas.
In each column, type and body are required.
If no ARGS group, extract arguments from usage.
Ignore header and footer description.
## Help Text
Usage: app [OPTIONS] ARG ARG2...
ARGUMENTS/ARGS:
    ARG           Desc
    ARG2...       Desc
    <A|B>         Desc
OPTIONS/SECTIONS:
    -s --long <VALUE>    Desc, [values: a, b, c]
    -t --tag             Desc
    --level <severity>   Value: low|high|critical
    --otp <Yes|No>       Desc
COMMANDS/SUBCOMMANDS:
    cmd, c
Footer description.
## Translated markdown table 
| type     | body               | choices           |
| -------- | ------------------ | ----------------- |
| argument | ARG                |                   |
| argument | ARG2...            |                   |
| argument | <A,B>              |                   |
| option   | -s  --long <VALUE> | a, b, c           |
| option   | -t  --tag          |                   |
| option   | --level <severity> | low,high,critical |
| option   | --otp <Yes,NO >    |                   |
| command  | cmd  c             |                   |
## Help Text I provides
$*
## Translated markdown table you replys
EOF
}

main() {
    if [[ -z "$OPENAI_API_KEY" ]]; then
        log_exit "Miss OPENAI_API_KEY environment variable"
    fi
    if [[ -z "$argc_help_file" ]]; then
        help_text="$(cat)"
    else
        help_text="$(cat "$argc_help_file")"
    fi
    query="$(prompt "$(echo "$help_text")" | tr  '\"' '`' | tr '\n' ' ')"
    result=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"$argc_model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$query\" }],
            \"temperature\": $argc_temperature
        }" | jq -r '.choices[0].message.content')
    echo -e "$result"
}

eval "$(argc --argc-eval "$0" "$@")"