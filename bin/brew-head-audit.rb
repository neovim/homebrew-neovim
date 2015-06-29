# This homebrew external command is used to override `brew audit`
# so that it will omit the HEAD only error.
#
# This file should be removed after neovim reaching stable release.

require "cmd/audit"

class FormulaAuditor
  def problems
    @problems.reject { |p| p == "Head-only (no stable download)" }
  end
end

Homebrew.audit
