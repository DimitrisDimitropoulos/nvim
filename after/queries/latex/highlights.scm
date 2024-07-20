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

(label_definition
  name: (curly_group_text) @label)

;; General environments
(begin
  command: _ @function.builtin
  name: (curly_group_text (text) @keyword.directive)
  (#not-has-ancestor? @keyword.directive math_environment))

(end
  command: _ @function.builtin
  name: (curly_group_text (text) @keyword.directive)
  (#not-has-ancestor? @keyword.directive math_environment))
