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

((generic_command) @operator
  (#any-of? @operator "\\hat" "\\cdot" "\\int" "\\div" "\\in" "\\leq" "\\sum" "\\neq" "\\geq" "\\times" "\\pm" "\\mp" "\\partial")
  (#set! "priority" 105))

((command_name) @type
  (#any-of? @type "\\mathrm" "\\mathcal" "\\mathbb" "\\mathbf" "\\mathit" "\\mathsf" "\\mathtt")
  (#set! "priority" 105))
