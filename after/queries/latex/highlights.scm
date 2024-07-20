; extends

(math_delimiter
  left_command: _ @punctuation.bracket
  left_delimiter: _ @punctuation.bracket
  right_command: _ @punctuation.bracket
  right_delimiter: _ @punctuation.bracket
)

((generic_command) @punctuation.bracket
  (#eq? @punctuation.bracket "\\bigg")
  (#set! "priority" 105))
