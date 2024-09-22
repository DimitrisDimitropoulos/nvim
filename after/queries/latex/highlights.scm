; extends

(math_delimiter
  left_command: _ @punctuation.bracket
  left_delimiter: _ @punctuation.bracket
  right_command: _ @punctuation.bracket
  right_delimiter: _ @punctuation.bracket
)

((generic_command) @punctuation.bracket
  (#any-of? @punctuation.bracket "\\big" "\\Big" "\\bigg" "\\Bigg")
  (#set! "priority" 105))

((generic_command) @operator
  (#any-of? @operator "\\hat" "\\cdot" "\\int" "\\div" "\\in" "\\leq" "\\sum" "\\neq" "\\geq" "\\times" "\\pm" "\\mp" "\\partial")
  (#set! "priority" 105))

((generic_command
  command: (command_name) @_name
  arg: (curly_group
    (_) @markup))
  (#eq? @_name "\\mathrm"))

(math_environment
  begin: (begin
    name: (curly_group_text
      text: (text) @markup.math))
  end: (end
    name: (curly_group_text
      text: (text) @markup.math)))
